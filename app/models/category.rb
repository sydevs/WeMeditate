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
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
