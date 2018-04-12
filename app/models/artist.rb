class Artist < ApplicationRecord

  # Associations
  has_many :tracks
  mount_uploader :image, GenericImageUploader

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :image, presence: true

end
