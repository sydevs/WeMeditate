
# When adding new locales, they must be appended to the end of the list or else the section :languages enum will be messed up.
I18n.available_locales = [:en, :ru]
I18n.enforce_available_locales = true

I18n.default_locale = :en

#I18n.fallbacks = true
Globalize.fallbacks = { ru: [:ru, :en] }
