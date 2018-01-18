class Category < ApplicationRecord
  extend FriendlyId

  has_many :article
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
end
