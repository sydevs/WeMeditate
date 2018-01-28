class ProgramTime < ApplicationRecord

  # Associations
  belongs_to :program_venue

  # Validations
  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

end
