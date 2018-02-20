class Artist < ApplicationRecord

  # Associations
  has_many :tracks
  mount_uploader :image, GenericImageUploader

end
