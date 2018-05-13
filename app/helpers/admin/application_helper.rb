module Admin::ApplicationHelper
  require 'i18n_data'

  LANGUAGE_TO_FLAG_MAP = {
    ru: 'ru',
    en: 'gb',
  }

  FILE_TYPE_METADATA = {
    image: { accepts: 'image/png, image/jpg', icon: 'image' },
    video: { accepts: 'video/mp4', icon: 'film' },
    audio: { accepts: 'audio/mp3', icon: 'volume up' },
    default: { accepts: '*', icon: 'file' },
  }

  def country_flag country_code
    content_tag :i, nil, class: "#{country_code} flag"
  end

  def language_flag l=locale
    country_flag LANGUAGE_TO_FLAG_MAP[l]
  end

  def file_type_accepts type
    type = :default unless FILE_TYPE_METADATA.has_key? type
    FILE_TYPE_METADATA[type][:accepts]
  end

  def file_type_icon type
    type = :default unless FILE_TYPE_METADATA.has_key? type
    FILE_TYPE_METADATA[type][:icon]
  end

  def human_enum_name model, attr, value = nil
    if value
      I18n.translate "activerecord.attributes.#{model.model_name.i18n_key}.#{attr.to_s.pluralize}.#{value}"
    else
      I18n.translate "activerecord.attributes.#{model.model_name.i18n_key}.#{attr.to_s.pluralize}.#{model.send(attr)}"
    end
  end

  def coordinates_url latitude, longitude
    "https://www.google.com/maps/search/?api=1&query=#{latitude}%2C#{longitude}"
  end

  # This function is taken from https://www.pluralsight.com/guides/ruby-ruby-on-rails/ruby-on-rails-nested-attributes
  def link_to_add_fields name = nil, f = nil, association = nil, options = nil, html_options = nil, &block
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block_given?

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

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!(f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )

    content_tag(:a, name, html_options, &block)
  end

  def subfield f, attribute, **args, &block
    render 'admin/fields/subfield', f: f, attribute: attribute, **args, &block
  end

  def file_input f, attribute, **args
    render 'admin/fields/file', f: f, attribute: attribute, **args
  end

  def select_input f, attribute, options, **args
    render 'admin/fields/select', f: f, attribute: attribute, options: options, **args
  end

  def multiselect_input f, attribute, options, **args
    render 'admin/fields/select', f: f, attribute: attribute, options: options, multiple: true, **args
  end

  def slug_input f, **args
    render 'admin/fields/slug', f: f, **args
  end

end
