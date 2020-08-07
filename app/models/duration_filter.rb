## DURATION FILTER
# An duration is the rough length of a Meditation.
# This is to let users filter meditations by how much time they have available.

# TYPE: FILTER
# A duration is considered to be a "Filter", which is used to categorize the Meditation model

class DurationFilter < ApplicationRecord

  # Extensions
  audited
  translates :published_at, :published

  # Concerns
  include Publishable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_many :meditations, counter_cache: true

  # Validations
  validates :minutes, presence: true

  # Scopes
  default_scope { order(:minutes) }
  scope :q, -> (q) { where(minutes: q) if q.present? }

  # Get all meditations that have content
  def self.has_content
    joins(meditations: [:translations, goal_filters: :translations]).where({
      meditation_translations: { state: Meditation.states[:published], locale: Globalize.locale },
      goal_filter_translations: { published: true, locale: Globalize.locale },
    }).uniq
  end

  # Returns a localized name for the duration filter, eg. "5 minutes"
  def name
    ActionController::Base.helpers.time_ago_in_words(minutes.minutes.from_now).titleize
  end

  def preview_name
    name
  end

end
