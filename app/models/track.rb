class Track < ApplicationRecord

  # Extensions
  translates :title, :subtitle

  # Associations
  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  mount_uploader :file, TrackUploader
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
