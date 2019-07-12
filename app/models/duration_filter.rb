## DURATION FILTER
# An duration is the rough length of a Meditation.
# This is to let users filter meditations by how much time they have available.

# TYPE: FILTER
# A duration is considered to be a "Filter", which is used to categorize the Meditation model

class DurationFilter < ApplicationRecord

  # Associations
  translates :published
  has_many :meditations

  # Validations
  validates :minutes, presence: true

  # Scopes
  default_scope { order(:minutes) }
  scope :published, -> { joins(:translations).where(published: true, duration_filter_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { where(minutes: q) if q.present? }

  def self.has_content
    joins(meditations: [:translations, goal_filters: :translations]).where({
      meditation_translations: { published: true, locale: I18n.locale },
      goal_filter_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  # Returns a localized name for the duration filter, eg. "5 minutes"
  def name
    ActionController::Base.helpers.time_ago_in_words(minutes.minutes.from_now).titleize
  end

end
