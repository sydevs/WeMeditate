class Meditation < ApplicationRecord

  # Extensions
  translates :name

  # Associations
  has_and_belongs_to_many :goal_filters
  has_one :duration_filters
  mount_uploader :file, TrackUploader
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
