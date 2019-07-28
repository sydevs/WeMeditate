class ApplicationRecord < ActiveRecord::Base

  MAX_INT = 2147483647

  before_validation :set_original_locale

  self.abstract_class = true

  def self.preload_for _mode
    self # Subclasses override this to provide real preloading behaviour
  end

  def publishable?
    respond_to?(:published)
  end

  def published?
    has_attribute?(:published) ? published : true
  end

  def reviewable?
    respond_to?(:draft)
  end

  def has_content?
    respond_to?(:content)
  end

  def viewable?
    respond_to?(:slug) && respond_to?(:metatags)
  end

  def translatable?
    respond_to?(:translated_locales)
  end

  # Retrieves the localized attribute without any fallback
  def get_localized_attribute attribute
    return self.send(attribute) unless translatable?

    if globalize.stash.contains?(Globalize.locale, attribute)
      globalize.stash.read(Globalize.locale, attribute)
    else
      translation_for(Globalize.locale).send(attribute)
    end
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  private

    def set_original_locale
      self.original_locale = I18n.locale.to_s if has_attribute?(:original_locale)
    end

end

class VimeoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not a vimeo id")
    end
  end
end
