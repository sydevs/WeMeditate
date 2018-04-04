
# When adding new locales, they must be appended to the end of the list or else the section :languages enum will be messed up.
I18n.available_locales = [:en, :ru]
I18n.enforce_available_locales = true
I18n.default_locale = :en


#fallbacks = {}
#I18n.available_locales.each do |locale|
#  fallbacks[locale] = I18n.available_locales
#end

#I18n.fallbacks = fallbacks
#Globalize.fallbacks = I18n.available_locales

#Globalize.fallbacks = { ru: [:ru, :en], en: [:en, :ru] }
