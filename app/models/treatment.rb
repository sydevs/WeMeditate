class Treatment < ApplicationRecord
  extend FriendlyId

  # Extensions
  translates :name, :slug, :excerpt, :content
  friendly_id :name, use: :globalize

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(treatment_translations: { locale: I18n.locale }) }

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
