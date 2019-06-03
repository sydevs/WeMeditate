## TRACK
# A musical track, which in the context of this website means music to meditate to.

# TYPE: RESOURCE
# A meditation is considered to be a "Resource".
# This means it is a standalone model, but it's content is specialized, and not defined using a collection of page sections

class Track < ApplicationRecord

  # Extensions
  translates :name

  # Associations
  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  belongs_to :artist, optional: true
  mount_uploader :audio, TrackUploader

  # Validations
  validates :name, presence: true
  validates :artist, presence: true
  validates :audio, presence: true
  validates :mood_filters, presence: true
  validates :instrument_filters, presence: true

  # Scopes
  scope :q, -> (q) { joins(:translations, :artist).where('track_translations.name ILIKE ? OR artists.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Include everything necessary to render the full content of this model
  def self.preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations, :artist, mood_filters: :translations, instrument_filters: :translations)
    end
  end

end
