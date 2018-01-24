class InstrumentFilter < ApplicationRecord
  has_and_belongs_to_many :tracks
  mount_uploader :file, IconUploader

  default_scope { order( :order ) }
end
