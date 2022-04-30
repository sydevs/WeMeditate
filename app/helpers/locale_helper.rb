## LOCALE HELPER
# Helps with locale-related methods

module LocaleHelper

  # Get the translated name for a given country_code
  def country_name country_code
    countries[country_code.to_s.upcase].titleize
  end

  # Get the translated names for each country for a given language
  def countries language = I18n.locale
    # Get the localized country names for the given locale, or default to english if there is an error
    I18nData.countries(language) rescue I18nData.countries
  end

  # Get the translated name for a given language
  # If no language code is given it will default to the current locale 
  # If `native: true` is passed, then it will return the language name in it's native tongue, instead of the current locale
  def language_name language = I18n.locale, native: false
    language = language.to_s.split('-')[0].to_sym

    languages(native ? language : I18n.locale)[language.to_s.upcase].titleize.split(/[,;]/)[0]
  end

  # Get the translated names for each language for a given language
  def languages language = I18n.locale
    language = language.to_s.split('-')[0].to_sym

    # Get the localized langugae names for the given locale, or default to english if there is an error
    I18nData.languages(language) rescue I18nData.languages
  end

  def locale_link url, locale: nil
    locale ||= I18n.locale
    return url if locale == :en
    return url if url[0] == '#' || url[0] == '?'
    return url unless /^(http[s]?:\/\/)?([^:\/\s]+)?(\/\w\w)?([\/\?#].*)?$/ =~ url # Parse url
    return url unless $2.nil? || $2 == Rails.configuration.public_host # URL points to We Meditate
    return url if $3.present? # Starts with a locale

    "/#{locale}#{$4}" # Prepend locale to url
  end

  def suggested_locale_for country: nil
    country_code = (country || request.headers["HTTP_CF_IPCOUNTRY"])&.upcase
    return nil unless country_code.present? && country_code != "xx"

    locales = CountryToLocalesMapping.country_code_locales(country_code)
    available_locales = locales.map(&:to_sym).intersection(Rails.configuration.published_locales)
    return available_locales.first if available_locales.present?

    locales = locales.map { |l| l.split('-').first.to_sym }
    available_locales = locales.intersection(Rails.configuration.published_locales)
    return available_locales.first if available_locales.present?
  end

end
