class ApplicationRecord < ActiveRecord::Base

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

end
