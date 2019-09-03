## GOAL FILTER
# An goal is what a specific guided Meditation tries to achieve. Eg. "Peace", "Forgiveness", etc

# TYPE: FILTER
# A goal is considered to be a "Filter", which is used to categorize the Meditation model

class GoalFilter < ApplicationRecord

  include Translatable

  # Extentions
  translates :name, :published_at, :published

  # Associations
  has_and_belongs_to_many :meditations
  mount_uploader :icon, SvgIconUploader

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  # Scopes
  default_scope { order(:order) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :q, -> (q) { with_translations(I18n.locale).joins(:translations).where('goal_filter_translations.name ILIKE ?', "%#{q}%") if q.present? }

  def self.has_content
    joins(meditations: [:translations, duration_filter: :translations]).where({
      meditation_translations: { published: true, locale: I18n.locale },
      duration_filter_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
