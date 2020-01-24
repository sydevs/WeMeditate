require 'i18n_data'

module Admin::ApplicationHelper

  # Language codes don't always line up with an appropriate flag to represent that language
  # So we define that mapping manually here.
  LANGUAGE_TO_FLAG_MAP = {
    ru: 'ru', # Russian
    en: 'gb', # English
    it: 'it', # Italian
    de: 'de', # German
    fr: 'fr', # French
    es: 'es', # Spanish
    pt: 'pt', # Portuguese
    nl: 'nl', # Dutch
    hy: 'am', # Armenian
    uk: 'ua', # Ukrainian
  }.freeze

  # The icon used for different levels of urgency
  URGENCY_ICON = {
    critical: 'red warning sign',
    important: 'orange warning sign',
    normal: 'warning sign',
    pending: 'grey warning sign',
  }.freeze

  # The icon used to represent each model in the system
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
    Author => 'id badge',
    User => 'user',
  }.freeze

  # Admin URLs require a big of special handling, to support all the abstraction that we do in the CMS
  def polymorphic_admin_path args, options = {}
    unless args.last.is_a?(Class)
      options[:id] = args.last.id
      options[:format] ||= nil
    end

    polymorphic_path(args, **options)
  end

  # Render a flag for a given country code
  def country_flag country_code
    content_tag :i, nil, class: "#{country_code} flag"
  end

  # Render a flag for a given language
  def language_flag language = locale
    country_flag LANGUAGE_TO_FLAG_MAP[language]
  end

  # Fetch the icon classes for a given urgency.
  def urgency_icon_key urgency
    URGENCY_ICON[urgency]
  end

  # Fetch the icon classes for a model.
  def model_icon_key model
    MODEL_ICON[model]
  end

  # Fetch the translated version of a model name.
  def human_model_name model, pluralization = :singular
    key = pluralization == :plural ? 'other' : 'one'
    translate(key, scope: [:activerecord, :models, model.model_name.i18n_key])
  end

  # Fetch the translated version of an enum's value.
  # If no value is provided, this method will get the current value from the given model.
  # If a value is provided then `model` can be a class instead of an ActiveRecord object.
  def human_enum_name model, attr, value = nil
    value ||= model.send(attr)
    value = (model.is_a?(Class) ? model : model.class).send(attr.to_s.pluralize).key(value) if value.is_a?(Integer)
    I18n.translate value, scope: [:activerecord, :attributes, model.model_name.i18n_key, attr.to_s.pluralize]
  end

  # Fetch the translated version of a model's attribute
  # `model` can either be a class or an ActiveRecord object, doesn't matter.
  def human_attribute_name model, attr
    I18n.translate attr, scope: [:activerecord, :attributes, model.model_name.i18n_key]
  end

  # Provides an easy link to view a set of coordinates on Google
  def coordinates_url latitude, longitude
    "https://www.google.com/maps/search/?api=1&query=#{latitude}%2C#{longitude}"
  end

  # Creates a mailto link for reporting any issues with the CMS
  def report_url
    report_url = "mailto:\"#{translate 'admin.report_issue.name'}\"<#{translate 'admin.report_issue.email'}>"
    report_url += "?subject=#{CGI.escape translate('admin.report_issue.subject')}"
    report_url += "&body=#{CGI.escape translate('admin.report_issue.body')}"
    report_url
  end

  # This is a more complex method which generates a summary of the content blocks for a given page.
  # Just to give an overview of the page content to a user, instead of showing them the whole content.
  def content_outline record
    blocks = record.content_blocks if record.parsed_content.present?
    return unless blocks

    content_tag :ul do
      # Loop through each block in the record, and generate a short piece of text describing that block.
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

        when 'video', 'structured' # Items list
          items = block['data']['items']&.map { |item| item['title'] }&.join(', ')

          case block['type']
          when 'structured'
            type = translate(block['data']['format'], scope: %i[admin content tunes format])
          else
            type = translate(block['type'], scope: %i[admin content blocks])
          end

          concat content_tag :li, "#{type.titleize}: #{items}"

        when 'paragraph', 'quote' # Word count
          type = translate(block['type'], scope: %i[admin content blocks])
          word_count = translate('admin.content.words', count: block['data']['text'].split.size)
          concat content_tag :li, tag.i("#{type}: #{word_count}")

        when 'list', 'catalog', 'image' # Items count
          item_count = translate('admin.content.items', count: block['data']['items'].split.size)

          case block['type']
          when 'catalog'
            type = translate(block['data']['type'], scope: %i[admin content tunes type])
          else
            type = translate(block['type'], scope: %i[admin content blocks])
          end

          concat content_tag :li, tag.i("#{type}: #{item_count}")

        when 'action' # Short text link
          type = translate(block['type'], scope: %i[admin content blocks])
          concat content_tag :li, tag.em(type) + tag.span(": [#{block['data']['text']}] → ") + tag.small(block['data']['url'])

        when 'whitespace' # Whitespace
          separators = {
            large: '==',
            medium: '—',
            small: '--',
          }

          concat content_tag :li, separators[block['data']['size'].to_sym] * 3

        else
          concat block.inspect
        end
      end
    end
  end

end
