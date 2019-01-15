class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.preload_for mode
    self # Subclasses will override this to provide real preloading behaviour
  end

  def reviewable?
    self.respond_to? :versions
  end

  def has_content?
    self.respond_to? :sections
  end

  def viewable?
    self.respond_to?(:slug) and self.respond_to?(:metatags)
  end

  def translatable?
    self.respond_to?(:translated_locales)
  end

end
