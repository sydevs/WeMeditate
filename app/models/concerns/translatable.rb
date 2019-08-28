## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Translatable

  extend ActiveSupport::Concern

  included do |base|
    # Do nothing for now
  end

  def translatable?
    true
  end

  def original_localization
    @original_localization ||= translation_for(original_locale)
  end

  # Retrieves the localized attribute without any fallback
  def get_localized_attribute attribute, locale = I18n.locale
    return self.send(attribute) unless translatable?

    if globalize.stash.contains?(locale, attribute)
      globalize.stash.read(locale, attribute)
    else
      translation_for(locale).send(attribute)
    end
  end

  private

    def set_original_locale
      self.original_locale = I18n.locale.to_s if has_attribute?(:original_locale) && original_locale.nil?
    end

end
