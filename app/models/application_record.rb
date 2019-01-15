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

  def default_metatags
    {
      'og:sitename' => I18n.translate('we_meditate'),
      'og:locale' => I18n.locale,
      'og:locale:alternate' => translated_locales,
      'og:article:published_time' => created_at.to_s(:db),
      'og:article:modified_time' => updated_at.to_s(:db),
      'twitter:site' => Rails.application.config.twitter_handle,
      'twitter:creator' => Rails.application.config.twitter_handle,
    }
  end

end
