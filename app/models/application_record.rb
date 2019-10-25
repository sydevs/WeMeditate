class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true
  include Sortable
  MAX_INT = 2147483647

  def self.preload_for _mode
    self # Subclasses override this to provide real preloading behaviour
  end

  %i[publishable contentable draftable stateable translatable viewable].each do |attribute|
     # Will be overrided by various concerns
    define_method :"#{attribute}?", -> { false }
    define_singleton_method :"#{attribute}?", -> { false }
  end

  def has_draft? _section = nil
    false # Will be overrided by the draftable concern
  end

  def has_translation? _section = nil
    true # Will be overrided by the translatable concern
  end
  
  # Implement a default name for every type of record
  def preview_name
    name = self[:name]
    name ||= parsed_draft['name'] if try(:parsed_draft).present?
    name ||= get_native_locale_attribute(:name, original_locale) if translatable?
    name ||= I18n.translate('admin.misc.no_translated_title')
  end

  def cache_key
    # We need to customize the cache key to factor in translations
    super + '-' + Globalize.locale.to_s
  end

end

# Validates a Vimeo ID
class VimeoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not a vimeo id")
    end
  end
end
