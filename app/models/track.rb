## TRACK
# A musical track, which in the context of this website means music to meditate to.

class Track < ApplicationRecord

  # Extensions
  translates :name, :published_at, :published

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
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :q, -> (q) { joins(:translations, :artist).where('track_translations.name ILIKE ? OR artists.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Include everything necessary to render the full content of this model
  def self.preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations, :artist, mood_filters: :translations, instrument_filters: :translations)
    end
  end

end
