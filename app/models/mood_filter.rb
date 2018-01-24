class MoodFilter < ApplicationRecord
  has_and_belongs_to_many :tracks

  default_scope { order( :order ) }
end
