class DurationFilter < ApplicationRecord

  # Associations
  has_many :meditations
  
  # Scopes
  validates :minutes, presence: true
  default_scope { order( :minutes ) }

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
