module Admin::ApplicationHelper
  require 'i18n_data'

  LANGUAGE_TO_FLAG_MAP = {
    ru: 'ru',
    en: 'gb',
  }
  
  #ActionView::Helpers::FormBuilder.class_eval do
  #  include ActionView::Helpers::TagHelper
  #
  #  def error(att)
  #    if object.errors.include? att
  #      content_tag :div, object.errors[att].to_s, class: 'ui error message'
  #    end
  #  end
  #end

  def country_flag country_code
    content_tag :i, nil, class: "#{country_code} flag"
  end

  def language_flag l=locale
    country_flag LANGUAGE_TO_FLAG_MAP[l]
  end

  # This function is taken from https://www.pluralsight.com/guides/ruby-ruby-on-rails/ruby-on-rails-nested-attributes
  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
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
      partial = association.to_s.singularize + '_fields'
    end
    
    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end
    
    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = '#'
    
    content_tag(:a, name, html_options, &block)
  end

end
