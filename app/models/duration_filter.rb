## DURATION FILTER
# An duration is the rough length of a Meditation.
# This is to let users filter meditations by how much time they have available.

# TYPE: FILTER
# A duration is considered to be a "Filter", which is used to categorize the Meditation model

class DurationFilter < ApplicationRecord

  # Associations
  has_many :meditations

  # Validations
  validates :minutes, presence: true

  #
  default_scope { order( :minutes ) }

  # Returns a localized name for the duration filter, eg. "5 minutes"
  def name
    ActionController::Base.helpers.time_ago_in_words(minutes.minutes.from_now).titleize
  end

end
