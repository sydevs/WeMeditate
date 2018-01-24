class Track < ApplicationRecord
  INSTRUMENTS = [ :voice, :sitar, :tabla, :flute ]

  enum mood: [ :cheerful, :peaceful, :joyful, :integration, :innocence ]

  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  mount_uploader :file, TrackUploader

end
