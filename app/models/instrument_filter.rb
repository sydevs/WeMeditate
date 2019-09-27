## INSTRUMENT FILTER
# An instrument filter signals what sounds are being used in a music Track,
# so that users can filter Tracks for just the kind of music they want to listen to.
# Eg. Sitar, Piano, Voice, Drums, etc

# TYPE: FILTER
# A goal is considered to be a "Filter", which is used to categorize the Track model

class InstrumentFilter < ApplicationRecord

  include Translatable

  # Extentions
  translates :name, :published_at, :published

  # Associations
  has_and_belongs_to_many :tracks, counter_cache: true
  mount_uploader :icon, IconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order(:order) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :q, -> (q) { with_translations(I18n.locale).joins(:translations).where('instrument_filter_translations.name ILIKE ?', "%#{q}%") if q.present? }

  def self.has_content
    joins(tracks: [:translations, mood_filters: :translations]).where({
      track_translations: { published: true, locale: I18n.locale },
      mood_filter_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
