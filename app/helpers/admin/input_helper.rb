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
      multiple = original_value.is_a?(Array) || draft_value.is_a?(Array)
      files = MediaFile.where(id: original_value)
      original_name = files.map(&:name).join(', ')
      original_value = files.map { |media| { name: media&.name, value: media&.id, url: media&.file_url } }

      files = MediaFile.where(id: draft_value)
      draft_name = files.map(&:name).join(', ')
      draft_value = files.map { |media| { name: media&.name, value: media&.id, url: media&.file_url } }

      # If there was only a single ID, then we only want a single value
      unless multiple
        original_value = original_value[0]
        draft_value = draft_value[0]
      end
    when :collection
      original_name = input[:collection].find { |i| i[1].to_s == original_value.to_s }.first
      draft_name = input[:collection].find { |i| i[1].to_s == draft_value.to_s }.first
    when :rich_text
      original_name = strip_tags(original_value)
      draft_name = strip_tags(draft_value)
    when :repeatable
      # TODO: Translate these next lines.
      original_name = pluralize(original_value.count, 'item')
      draft_name = pluralize(draft_value.count, 'item')
    when :decorations
      original_name = original_value ? original_value['enabled'].reject(&:blank?).join(', ') : nil
      draft_name = draft_value ? draft_value['enabled'].reject(&:blank?).join(', ') : nil
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
    # TODO: Translate this
    data = { tooltip: translate("action.draft.#{type}_tooltip", value: name), value: value, position: 'top right', inverted: true }
    content = "<i class=\"sync icon\"></i> #{translate "action.draft.#{type}"}".html_safe
    tag.div content, class: "ui tiny compact right floated basic #{type} button", data: data
  end

  def draftable_field form, attribute, type: :string, label: true, disabled: false, input: {}, wrapper: {}, **args
    key = (type == :association ? "#{attribute}_id" : attribute.to_s)
    has_draft = args[:draft].present? || form.object.draft&.has_key?(key)
    value = args.key?(:value) ? args[:value] : form.object.send(key)

    wrapper[:class] = "#{wrapper[:class] || ''} #{'draft' if has_draft}"
    wrapper[:data] = (wrapper[:data] || {}).merge({ draft: type })

    form.input attribute, label: false, disabled: disabled, required: wrapper[:required], wrapper_html: wrapper.except!(:required) do
      if has_draft
        draft = args[:draft] || form.object.draft[key]
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
    end
  end

  def draftable_media_field form, attribute, multiple: false, type: :image, preview: nil, **args
    if not form.object.is_a? Section and form.object.new_record?
      return form.input(attribute, disabled: true, input_html: { value: t('messages.cant_add_media_to_new_record', target: form.object.model_name.human.downcase) })
    end

    value = args.key?(:value) ? args[:value] : form.object.send(attribute)
    draft_value = args.key?(:draft) ? args[:draft] : (form.object.draft if form.object.draft&.key?(attribute))

    draftable_field form, attribute, type: :media, value: value, draft: draft_value, wrapper: (args[:wrapper] || {}) do |val|
      args[:input] ||= {}
      args[:input][:value] = val
      media_input form, attribute, multiple: multiple, type: type, preview: preview, input: args[:input]
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

  def draftable_date_field form, attribute = :date
    draftable_field form, attribute do |value|
      content_tag :div, class: 'ui date picker' do
        form.input_field attribute, as: :string, value: value
      end
    end
  end

  def media_input form, attribute, multiple: false, type: :image, preview: nil, input: {}
    value = input.key?(:value) ? input[:value] : form.object.send(attribute)
    media = MediaFile.find_by(id: value) unless multiple
    input[:name] ||= "#{form.object_name}[#{attribute}]"
    input[:name] += '[]' if multiple
    input.except! :value

    content_tag :div, class: 'ui media input', data: { multiple: multiple, type: type, key: attribute } do
      # TODO: Translate the following line - or change it to the name attributes
      label = (multiple ? pluralize(value&.size || 0, 'file') : media&.name)
      input_tag = tag.input(nil, type: :text, placeholder: input[:placeholder] || t("action.choose_file.#{type}.#{multiple ? 'multiple' : 'single'}"), value: label)
      concat tag.div input_tag, class: 'handle'

      if multiple and value.present?
        value.each do |val|
          concat form.input_field attribute, as: :hidden, value: val, **input
        end
      else
        concat form.input_field attribute, as: :hidden, value: value, **input
      end

      if not multiple and preview != false
        if preview && type == :image
          concat tag.a tag.img(src: media&.file_url), class: 'ui rounded image', href: media&.file_url, target: '_blank'
        else
          concat tag.a t('action.show'), class: 'ui basic small compact button', href: media&.file_url, target: '_blank', style: ('display: none' unless media&.file_url).to_s
        end
      end
    end
  end

  def decoration_type_input form, decoration
    form.input decoration, {
      label: decoration_type_label(decoration),
      as: :boolean,
      wrapper: :ui_checkbox,
      checked_value: decoration.to_s,
      unchecked_value: '',
      required: false,
      input_html: {
        name: "#{form.object_name}[decorations][enabled][]",
        checked: form.object.has_decoration?(decoration, draft: true),
      },
    }
  end

  def decoration_config_dropdown form, decoration, attribute, options
    content_tag :div, class: 'ui inline dropdown' do
      result = hidden_field_tag "#{form.object_name}[decorations][options][#{decoration}][]", (options & form.object.decoration_options(decoration, draft: true))[0]
      result.concat content_tag(:i, nil, class: 'dropdown icon')
      result.concat content_tag(:div, decoration_option_label(attribute), class: 'default text')
      menu = content_tag(:div, class: 'menu') do
        options.collect do |value|
          concat content_tag(:div, decoration_option_label(attribute, value), class: 'item', data: { value: value })
        end
      end

      result.concat(menu)
    end
  end

  def decoration_config_sidetext form
    form.input_field :sidetext, {
      as: :string,
      wrapper: :ui_input,
      required: false,
      name: "#{form.object_name}[decorations][sidetext]",
      value: form.object.decoration_sidetext(draft: true),
    }
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
