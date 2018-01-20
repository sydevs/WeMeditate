class Category < ApplicationRecord
  extend FriendlyId

  has_many :articles
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
end
