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

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
