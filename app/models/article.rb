class Article < ApplicationRecord
  extend FriendlyId

  has_paper_trail
  has_many :article_content
  friendly_id :title, use: :slugged

  validates :title, presence: true
  
end
