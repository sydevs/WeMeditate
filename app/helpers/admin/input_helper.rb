require 'pathname'

module Admin::InputHelper

  FILE_TYPE_METADATA = {
    image: { accepts: 'image/png, image/jpg', icon: 'image' },
    video: { accepts: 'video/mp4', icon: 'film' },
    audio: { accepts: 'audio/mp3', icon: 'volume up' },
    default: { accepts: '*', icon: 'file' },
  }.freeze

  def file_type_accepts type
    type = :default unless FILE_TYPE_METADATA.key? type
    FILE_TYPE_METADATA[type][:accepts]
  end

  def file_type_icon type
    type = :default unless FILE_TYPE_METADATA.key? type
    FILE_TYPE_METADATA[type][:icon]
  end

  def draft_reset_buttons type, original_value, draft_value, input = nil
    case type
    when :media
      if original_value
        media_file = MediaFile.find(original_value)
        original_name = media_file.name
        original_value = { id: original_value, src: media_file.file.url(:medium) }
      else
        original_name = translate('admin.draft.no_image')
        original_value = { id: nil, src: nil }
      end

      if draft_value
        media_file = MediaFile.find(draft_value)
        draft_name = media_file.name
        draft_value = { id: draft_value, src: media_file.file.url(:medium) }
      else
        draft_name = translate('admin.draft.no_image')
        draft_value = { id: nil, src: nil }
      end
    when :collection
      original_name = input[:collection].find { |i| i[1].to_s == original_value.to_s }.first
      draft_name = input[:collection].find { |i| i[1].to_s == draft_value.to_s }.first
    when :repeatable
      original_name = translate('admin.draft.items', count: original_value.count)
      draft_name = translate('admin.draft.items', count: draft_value.count)
    when :toggle
      original_name = ActiveModel::Type::Boolean.new.cast(original_value) ? 'True' : 'False' 
      draft_name = ActiveModel::Type::Boolean.new.cast(draft_value) ? 'True' : 'False' 
    when :content
      original_count = original_value ? original_value['blocks'].count : 0
      original_name = translate('admin.draft.content.original', count: original_value.count)
      draft_name = translate('admin.draft.content.draft', count: draft_value['blocks'].count)
    else
      original_name = original_value
      draft_name = draft_value
    end

    capture do
      concat draft_reset_button original_name, original_value, 'reset'
      concat draft_reset_button draft_name, draft_value, 'redo'
    end
  end

  def draft_reset_button name, value, type
    data = { tooltip: translate("#{type}_tooltip", scope: %i[admin action draft], value: name), value: value, position: 'top right', inverted: true }
    content = "<i class=\"sync icon\"></i> #{translate type, scope: %i[admin action draft]}".html_safe
    tag.div content, class: "ui tiny compact right floated basic #{type} button", data: data
  end

  def draftable_field form, attribute, type: :string, label: true, disabled: false, input: {}, wrapper: {}, **args
    key = (type == :association ? "#{attribute}_id" : attribute.to_s)
    has_draft = args[:draft].present? || form.object.parsed_draft&.has_key?(key)
    value = args.key?(:value) ? args[:value] : form.object.send(key)

    wrapper[:class] = "#{wrapper[:class] || ''} #{'draft' if has_draft}"
    wrapper[:data] = (wrapper[:data] || {}).merge({ draft: type })

    form.input attribute, label: false, disabled: disabled, required: wrapper[:required], wrapper_html: wrapper.except!(:required) do
      if has_draft
        draft = args[:draft] || form.object.parsed_draft[key]
        concat draft_reset_buttons(type, value, draft, input)
        value = draft
      end

      if label.is_a? String
        concat form.label attribute, label: label
      elsif label
        concat form.label attribute
      end

      if block_given?
        concat yield(value)
      else
        concat form.input_field attribute, **input.merge(disabled: disabled, value: value, selected: value)
      end

      concat form.hint args[:hint] if args[:hint].present?
    end
  end

  def draftable_publish_field form, **args
    args[:label] = translate('activerecord.attributes.generic.ready_to_publish')
    args[:value] = form.object.get_localized_attribute(:published)

    draftable_field form, :published, type: :toggle, **args do |val|
      capture do 
        concat publish_input form, :published, val
      end
    end
  end

  def draftable_media_field form, attribute, type: :image, preview: true, **args
    key = "#{attribute}_id"
    value = args[:value] ? args[:value] : form.object.send(key)
    draft_value = args[:draft] ? args[:draft] : (form.object.draft.send(key) if form.object.draft&.key?(key))

    draftable_field form, key, type: :media, value: value, draft: draft_value, wrapper: (args[:wrapper] || {}) do |val|
      capture do
        concat form.hidden_field(key, value: val)
        concat form.input_field(attribute, as: :file, file: val, accept: file_type_accepts(type))

        if preview && type == :image && val.present?
          concat tag.div(tag.img(src: MediaFile.find(val).file.url(:medium)), class: 'ui rounded image') 
        end
      end
    end
  end

  def draftable_slug_field form, url
    url = "#{Pathname(url).dirname}/"

    draftable_field form, :slug do |value|
      content_tag :div, class: 'ui labeled slug input' do
        concat tag.div url, class: 'ui basic label'
        concat form.input_field :slug, value: value
      end
    end
  end

  def draftable_date_field form, attribute = :date, hint: nil
    draftable_field form, attribute do |value|
      content_tag :div, class: 'ui date picker' do
        concat form.input_field attribute, as: :string, value: value
        concat form.hint hint if hint
      end
    end
  end

  def publish_input form, attribute, checked = nil, enabled: true
    checked = form.object.send(attribute) if checked.nil?
    content_tag :div, class: "ui#{' disabled' unless enabled} toggle checkbox" do
      concat form.input_field(attribute, as: :boolean, checked: checked)
      concat tag.label translate 'admin.messages.make_public', page: form.object.model_name.human(count: 1).downcase unless form.object.reviewable?
    end
  end

  # This function is taken from https://www.pluralsight.com/guides/ruby-ruby-on-rails/ruby-on-rails-nested-attributes
  def link_to_add_fields name = nil, form = nil, association = nil, options = nil, html_options = nil, &block
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    if block_given?
      form = name
      association = form
      options = association
      html_options = options
    end

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = {}
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = 'admin/' + association.to_s.pluralize + '/form'
    end

    if options.include? :new_object
      new_object = options[:new_object]
    else
      new_object = form.object.class.reflect_on_association(association).klass.new
    end

    puts new_object.inspect

    # Render the form fields from a file with the association name provided
    fields = form.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!(f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI.escapeHTML(fields)

    content_tag(:a, name, html_options, &block)
  end

end
