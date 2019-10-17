module LocaleHelper

    def country_name country
      countries[country.to_s.upcase].titleize
    end

    def countries language = locale
      I18nData.countries(language) rescue I18nData.countries
    end

    def language_name language = locale, native: false
      languages(native ? language : locale)[language.to_s.upcase].titleize
    end

    def languages language = locale
      I18nData.languages(language) rescue I18nData.languages
    end
    
end