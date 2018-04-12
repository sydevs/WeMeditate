class GoalFilter < ApplicationRecord

  # Extentions
  translates :name

  # Associations
  has_and_belongs_to_many :meditations

  # Validations
  validates :name, presence: true

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(goal_filter_translations: { locale: I18n.locale }) }

end
