## DRAFTABLE CONCERN
# This concern should be added to models that require an admin to approve any update,
# before it is reflected in the public-facing website.

module Translatable

  extend ActiveSupport::Concern

  def translatable?
    true
  end

  included do |base|
    throw "Translations must be defined to make the `#{base.model_name}` model `Translatable`" unless base.respond_to?(:translated_attribute_names)

    base.scope :foreign_locale, -> { where.not(original_locale: I18n.locale) }
    base.scope :not_translated, -> { foreign_locale.where.not(id: base.left_outer_joins(:translations).where(base::Translation.table_name => { locale: I18n.locale }).reorder(nil)) }
    base.scope :needs_translation, -> (user) { can_translate(user).not_translated }
    
    if base.stateable?
      base.scope :can_translate, -> (user) { foreign_locale.with_translations.where.not(state: base.states[:archived]).where(original_locale: user.available_languages) }
    else
      base.scope :can_translate, -> (user) { foreign_locale.where(original_locale: user.available_languages) }
    end

    if base.translated_attribute_names.include? :published_at
      base.scope :incomplete_translation, -> { with_translations.where(published_at: nil) }
      base.scope :translatable, -> (user) { needs_translation(user).or(incomplete_translation.can_translate(use)) }
    end

    base.before_validation :set_original_locale

    def self.translatable?
      true
    end
  end

  def needs_translation? user
    #self.class.needs_translation(user).find_by(id: id).present?
    !has_translation?
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
  def get_native_locale_attribute attribute, locale = I18n.locale
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
