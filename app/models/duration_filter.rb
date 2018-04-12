class DurationFilter < ApplicationRecord

  # Associations
  has_many :meditations

  # Scopes
  validates :minutes, presence: true
  default_scope { order( :minutes ) }

  def name
    ActionController::Base.helpers.time_ago_in_words(minutes.minutes.from_now).titleize
  end

end
