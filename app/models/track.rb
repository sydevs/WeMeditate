class Track < ApplicationRecord

  # Extensions
  translates :title, :subtitle

  # Associations
  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  mount_uploader :audio, TrackUploader

  alias name title
  
end
