class ApplicationRecord < ActiveRecord::Base

  MAX_INT = 2147483647

  self.abstract_class = true

  include Sortable

  def self.preload_for _mode
    self # Subclasses override this to provide real preloading behaviour
  end

  def publishable?
    respond_to?(:published)
  end

  def published?
    has_attribute?(:published) ? published : true
  end

  def viewable?
    respond_to?(:slug) && respond_to?(:metatags)
  end

  def has_content?
    false
  end

  def draftable?
    false
  end

  def has_draft? _section = nil
    false
  end

  def translatable?
    false
  end

  def has_translation? _section = nil
    true
  end
  
  def preview_name
    name = self[:name]
    name ||= parsed_draft['name'] if try(:parsed_draft).present?
    name ||= get_localized_attribute(:name, original_locale) if translatable?
    name ||= I18n.translate('admin.misc.no_translated_title')
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  def sort

  end

  def filter

  end

end

class VimeoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not a vimeo id")
    end
  end
end
