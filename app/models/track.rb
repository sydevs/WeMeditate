## TRACK
# A musical track, which in the context of this website means music to meditate to.

require 'taglib' unless Gem.win_platform?

class Track < ApplicationRecord

  # Extensions
  audited
  translates :name, :published_at, :published

  # Concerns
  include Publishable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_and_belongs_to_many :mood_filters
  has_and_belongs_to_many :instrument_filters
  has_and_belongs_to_many :artists, optional: true
  mount_uploader :audio, TrackUploader

  # Validations
  validates :name, presence: true
  validates :artists, presence: true
  validates :audio, presence: true
  # validates :mood_filters, presence: true
  validates :instrument_filters, presence: true

  # Scopes
  scope :q, -> (q) { with_translation.joins(:translations, :artists).where('track_translations.name ILIKE ? OR artists.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Callbacks
  before_save :parse_duration

  # Include everything necessary to render the full content of this model
  def self.preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations, :artists, mood_filters: :translations, instrument_filters: :translations)
    end
  end

  # A string representation of the duration of this track
  def duration_as_string
    Time.at(duration).utc.strftime('%M:%S') if try(:duration)
  end

  private

    # Use the TagLib library to extract the duration of this track before it is saved.
    def parse_duration
      return if Gem.win_platform?
      return unless audio.present? && (duration.nil? || audio_changed?)

      # This can only be run when the audio file is changed because the file will be stored in the cache.
      # Once the audio file is on the remote server this method won't work.
      ::TagLib::FileRef.open(audio.file.path) do |file|
        self.duration = file.audio_properties.length unless file.null?
      end
    end

end
