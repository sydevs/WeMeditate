## MOOD FILTER
# A mood refers to the feeling given by a particular music track, so that users can filter by what they want to hear.

# TYPE: FILTER
# A mood is considered to be a "Filter", which is used to categorize the Track model

class MoodFilter < ApplicationRecord

  include Translatable

  # Extensions
  translates :name, :published_at, :published

  # Associations
  has_and_belongs_to_many :tracks
  mount_uploader :icon, IconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order(:order) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :q, -> (q) { joins(:translations).where('mood_filter_translations.name ILIKE ?', "%#{q}%") if q.present? }

  def self.has_content
    joins(tracks: [:translations, instrument_filters: :translations]).where({
      track_translations: { published: true, locale: I18n.locale },
      instrument_filter_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
