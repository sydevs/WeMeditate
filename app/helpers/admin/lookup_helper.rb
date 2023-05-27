require 'i18n_data'

module Admin::LookupHelper

  # Language codes don't always line up with an appropriate flag to represent that language
  # So we define that mapping manually here.
  LANGUAGE_TO_FLAG_MAP = {
    en: 'gb', # UK for English
    ru: 'ru', # Russian
    it: 'it', # Italian
    de: 'de', # German
    fr: 'fr', # French
    es: 'es', # Spanish
    pt: 'pt', # Portuguese
    nl: 'nl', # Dutch
    hy: 'am', # Armenian
    uk: 'ua', # Ukrainian
    :'pt-br' => 'br', # Brazilian
    hi: 'in', # Hindi
    tr: 'tr', # Turkish
    ro: 'ro', # Romanian
    cs: 'cz', # Czech
    sv: 'se', # Swedish
    pl: 'pl', # Polish
    bg: 'bg', # Bulgarian
    fa: 'ir', # Iran for Farsi
    el: 'gr', # Greece for Greek
    ko: 'kr', # South Korea for Korean
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
    PromoPage => 'star',
    SubtleSystemNode => 'sun',
    Stream => 'film',
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

end
