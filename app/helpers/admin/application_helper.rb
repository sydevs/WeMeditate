require 'i18n_data'

module Admin
  module ApplicationHelper

    LANGUAGE_TO_FLAG_MAP = {
      ru: 'ru',
      en: 'gb',
      it: 'it',
    }.freeze

    def country_flag country_code
      content_tag :i, nil, class: "#{country_code} flag"
    end

    def language_flag language = locale
      country_flag LANGUAGE_TO_FLAG_MAP[language]
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

    def content_outline blocks
      # TODO: Translate
      content_tag :ul do
        for block in blocks
          case block['type']
          when 'splash', 'header', 'textbox' # Bold title
            field = block['type'] == 'header' ? 'text' : 'title'
            concat content_tag :li, tag.strong(block['data'][field])
            concat content_tag :li, tag.i("#{block['type'].titleize}: #{pluralize block['data']['text'].split.size, 'word'}") if block['type'] == 'textbox' && !block['data']['asVideo']
          when 'form' # Content
            concat content_tag :li, "#{block['type'].titleize}: #{block['data']['title']}"
          when 'video', 'link', 'structured' # Items list
            type = block['type'] == 'video' ? block['type'] : block['data']['format']
            field = block['type'] == 'link' ? 'name' : 'title'
            items = block['data']['items']&.map { |item| item[field] }&.join(', ')
            concat content_tag :li, "#{type.titleize}: #{items}"
          when 'paragraph', 'quote' # Word count
            concat content_tag :li, tag.i("#{block['type'].titleize}: #{pluralize block['data']['text'].split.size, 'word'}")
          when 'image' # Image count
            concat content_tag :li, "#{block['type'].titleize}: #{pluralize block['data']['items'].length, 'image'}"
          else
            concat block.inspect
          end
        end
      end
    end

  end
end

