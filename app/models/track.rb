## TRACK
# A musical track, which in the context of this website means music to meditate to.

# TYPE: RESOURCE
# A meditation is considered to be a "Resource".
# This means it is a standalone model, but it's content is specialized, and not defined using a collection of page sections

class Track < ApplicationRecord

  # Extensions
  translates :title

  # Associations
  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  belongs_to :artist, optional: true
  mount_uploader :audio, TrackUploader

  # Validations
  validates :title, presence: true
  validates :audio, presence: true
  validates :mood_filters, presence: true
  validates :instrument_filters, presence: true


  # TODO: Change the database so that Track uses the same database name for it's name/title as every other resource.
  alias name title

  # Include everything necessary to render the full content of this model
  def self.includes_content
    includes(:translations, :artist, mood_filters: :translations, instrument_filters: :translations)
  end
end
