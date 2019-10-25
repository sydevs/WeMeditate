## GOAL FILTER
# An goal is what a specific guided Meditation tries to achieve. Eg. "Peace", "Forgiveness", etc

# TYPE: FILTER
# A goal is considered to be a "Filter", which is used to categorize the Meditation model

class GoalFilter < ApplicationRecord

  # Extentions
  audited
  translates :name, :published_at, :published

  # Concerns
  include Publishable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_and_belongs_to_many :meditations, counter_cache: true
  mount_uploader :icon, SvgIconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order(:order) }
  scope :q, -> (q) { with_translation.joins(:translations).where('goal_filter_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Get all meditations that have content
  def self.has_content
    joins(meditations: [:translations, duration_filter: :translations]).where({
      meditation_translations: { state: Meditation.states[:published], locale: I18n.locale },
      duration_filter_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  # Preload the translations
  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
