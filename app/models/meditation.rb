class Meditation < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :audio
  friendly_id :name, use: :globalize

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_translated_uploader :audio, TrackUploader
  mount_uploader :image, GenericImageUploader

  # Validations
  validates :name, presence: true
  validates :image, presence: true
  validates :audio, presence: true
  validates :duration_filter, presence: true
  validates :goal_filters, presence: true

  alias thumbnail image
end
