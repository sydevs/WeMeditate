require 'i18n_data'

module Admin
  module ApplicationHelper

    LANGUAGE_TO_FLAG_MAP = {
      ru: 'ru',
      en: 'gb',
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

    def published_at_detail_message record
      if not record.published_at
        translate 'tags.unpublished_draft'
      elsif record.has_draft?
        translate 'tags.published_ago', time_ago: time_ago_in_words(record.published_at)
      else
        translate 'tags.published'
      end
    end

    def updated_at_detail_message record
      date = record.has_draft? ? record.updated_at : (record.published_at || record.updated_at)
      translate 'tags.updated_ago', time_ago: time_ago_in_words(date)
    end

  end
end

