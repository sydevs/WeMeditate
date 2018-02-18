class InstrumentFilter < ApplicationRecord
  
  # Extentions
  translates :name

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :icon, IconUploader

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(instrument_filter_translations: { locale: I18n.locale }) }

end
