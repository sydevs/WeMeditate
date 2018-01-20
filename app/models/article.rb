class Article < ApplicationRecord
  extend FriendlyId

  has_paper_trail
  belongs_to :category
  has_many :sections
  friendly_id :title, use: :slugged

  validates :title, presence: true
  
end
