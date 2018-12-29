## ARTIST
# An artist is the musical performer of a Track

# TYPE: FILTER
# An artist is considered to be a "Filter", which is used to categorize the Track model

class Artist < ApplicationRecord

  # Associations
  has_many :tracks
  mount_uploader :image, GenericImageUploader

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :image, presence: true

end
