require 'i18n_data'

module Admin
  module ApplicationHelper

    LANGUAGE_TO_FLAG_MAP = {
      ru: 'ru',
      en: 'gb',
      it: 'it',
    }.freeze

    URGENCY_ICON = {
      critical: 'red warning sign',
      important: 'orange warning sign',
      normal: 'warning sign',
    }.freeze

    MODEL_ICON = {
      Article => 'file text',
      StaticPage => 'file',
      SubtleSystemNode => 'sun',
      Meditation => 'fire',
      Treatment => 'first aid',
      Track => 'music',
      Category => 'hashtag',
      MoodFilter => 'filter',
      InstrumentFilter => 'filter',
      GoalFilter => 'filter',
      DurationFilter => 'clock',
      Artist => 'user',
      User => 'user',
    }.freeze

    def polymorphic_admin_path args, options = {}
      if args.last.is_a?(Class)
        polymorphic_path(args, **options)
      else
        options[:id] = args.last.id
        options[:format] ||= nil
        polymorphic_path(args, **options)
      end
    end

    def country_flag country_code
      content_tag :i, nil, class: "#{country_code} flag"
    end

    def language_flag language = locale
      country_flag LANGUAGE_TO_FLAG_MAP[language]
    end

    def language_name language = locale
      I18nData.languages(locale)[language.to_s.upcase]
    end

    def urgency_icon_key urgency
      URGENCY_ICON[urgency]
    end

    def model_icon_key model
      MODEL_ICON[model]
    end

    def human_enum_name model, attr, value = nil
      value ||= model.send(attr)
      I18n.translate value, scope: [:activerecord, :attributes, model.model_name.i18n_key, attr.to_s.pluralize]
    end

    def human_attribute_name model, attr
      I18n.translate attr, scope: [:activerecord, :attributes, model.model_name.i18n_key]
    end

    def coordinates_url latitude, longitude
      "https://www.google.com/maps/search/?api=1&query=#{latitude}%2C#{longitude}"
    end

    def content_outline record
      record.content = JSON.parse(record.content) unless record.content.nil? || record.content.is_a?(Hash)
      blocks = record.content['blocks'] if record.content.present?
      return unless blocks

      content_tag :ul do
        for block in blocks
          case block['type']
          when 'splash', 'header', 'textbox' # Bold title
            field = block['type'] == 'header' ? 'text' : 'title'
            title = block['data'][field]
            type = translate(block['type'], scope: %i[admin content blocks])
            word_count = block['data']['text'] ? block['data']['text'].split.size : 0
            word_count = translate('admin.content.words', count: word_count)

            concat content_tag :li, tag.strong(title)
            concat content_tag :li, tag.i("#{type}: #{word_count}") if block['type'] == 'textbox' && !block['data']['asVideo']

          when 'form' # Content
            concat content_tag :li, "#{block['type'].titleize}: #{block['data']['title']}"

          when 'video', 'link', 'structured' # Items list
            field = block['type'] == 'link' ? 'name' : 'title'
            items = block['data']['items']&.map { |item| item[field] }&.join(', ')

            if block['type'] == 'video'
              type = translate(block['type'], scope: %i[admin content blocks])
            else
              type = translate(block['data']['format'], scope: %i[admin content tunes format])
            end

            concat content_tag :li, "#{type.titleize}: #{items}"

          when 'paragraph', 'quote' # Word count
            type = translate(block['type'], scope: %i[admin content blocks])
            word_count = translate('admin.content.words', count: block['data']['text'].split.size)
            concat content_tag :li, tag.i("#{type}: #{word_count}")

          when 'list', 'image' # Items count
            type = translate(block['type'], scope: %i[admin content blocks])
            item_count = translate('admin.content.items', count: block['data']['items'].split.size)
            concat content_tag :li, tag.i("#{type}: #{item_count}")

          else
            concat block.inspect
          end
        end
      end
    end

  end
end

