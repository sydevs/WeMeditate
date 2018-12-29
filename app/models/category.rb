## CATEGORY
# Articles are placed into different categories which are defined by this model.

# TYPE: FILTER
# An category is considered to be a "Filter", which is used to categorize the Article model

class Category < ApplicationRecord
  extend FriendlyId

  # Extensions
  translates :name, :slug
  friendly_id :name, use: :globalize

  # Associations
  has_many :articles

  # Validations
  validates :name, presence: true, uniqueness: true

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(category_translations: { locale: I18n.locale }) }

end
