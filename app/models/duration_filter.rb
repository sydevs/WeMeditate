class DurationFilter < ApplicationRecord

  # Extentions
  translates :name

  # Associations
  has_many :meditations
  
  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(duration_filter_translations: { locale: I18n.locale }) }

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
