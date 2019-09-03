## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Translatable

  extend ActiveSupport::Concern

  included do |base|
    base.scope :needs_translation, -> (user) { where.not(id: published.pluck(:id)).where(original_locale: user.available_languages) }
    base.before_validation :set_original_locale
  end

  def translatable?
    true
  end

  def has_translation? section = nil, locale: I18n.locale, check_draft: true
    return false unless translated_locales.include?(locale)

    if section == :content
      return true if content.present?
    elsif section == :details
      return true if try(:name).present?
    else
      return true
    end

    return true if check_draft && has_draft?(section)
    false
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
