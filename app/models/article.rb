class Article < ApplicationRecord
  extend FriendlyId

  has_paper_trail
  belongs_to :category
  has_many :sections, -> { order(:order) }
  friendly_id :title, use: :slugged

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  enum priority: { home_page: 2, high: 1, normal: 0, low: -1 }
  
  default_scope { order(priority: :desc) }
end
