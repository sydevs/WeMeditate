class MoodFilter < ApplicationRecord

  # Extensions
  translates :name

  # Associations
  has_and_belongs_to_many :tracks

  # Scopes
  default_scope { order( :order ) }
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
