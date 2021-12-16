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

  def locale_link url
    return url if I18n.locale == :en
    return url if url[0] == '#' || url[0] == '?'

    uri = URI::parse(url)
    return url unless uri.host.nil? || Rails.configuration.public_host == uri.host
    
    url = strip_url(url) if Rails.configuration.public_host == uri.host
    url = '/' + url unless url[0] == '/'
    return url if url =~ /^\/[a-z][a-z][^a-zA-Z0-9]/ # Starts with a locale

    "/#{I18n.locale}#{url}"
  end

  def strip_url url
    uri = URI::parse(url)
    result = uri.path
    result += "##{uri.fragment}" if uri.fragment.present?
    result += "?#{uri.query}" if uri.query.present?
    result
  end

end