class Meditation < ApplicationRecord
  extend FriendlyId

  # Extensions
  translates :name, :slug
  friendly_id :name, use: :globalize

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_uploader :file, TrackUploader
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
