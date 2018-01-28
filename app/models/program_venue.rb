class ProgramVenue < ApplicationRecord

  # Associations
  has_many :program_times
  belongs_to :city

  # Validations
  validates :address, presence: true
  accepts_nested_attributes_for :program_times, reject_if: :all_blank, allow_destroy: true

end
