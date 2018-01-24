class InstrumentFilter < ApplicationRecord
  
  # Extentions
  translates :name

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :file, IconUploader

  # Scopes
  default_scope { order( :order ) }
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
