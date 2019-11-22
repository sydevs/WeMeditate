# When adding new locales, they must be appended to the end of the list or else the section :languages enum will be messed up.
I18n.available_locales = %i[en ru it de fr es pt nl hy uk]
I18n.enforce_available_locales = true
I18n.default_locale = :en

published_locales = ENV['PUBLISHED_LOCALES'] ? ENV['PUBLISHED_LOCALES'].split(',').map(&:strip).map(&:to_sym) : []
published_locales = %i[en ru it] if Rails.env.development? && published_locales.empty?
Rails.configuration.published_locales = published_locales & I18n.available_locales
