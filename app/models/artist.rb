## ARTIST
# An artist is the musical performer of a Track

# TYPE: FILTER
# An artist is considered to be a "Filter", which is used to categorize the Track model

class Artist < ApplicationRecord

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :image, ImageUploader

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :image, presence: true

  # Scope
  scope :q, -> (q) { where('name ILIKE ?', "%#{q}%") if q.present? }

end
