class Meditation < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :audio
  friendly_id :name, use: :globalize

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_translated_uploader :audio, TrackUploader
  mount_uploader :image, GenericImageUploader
  
  alias thumbnail image
end
