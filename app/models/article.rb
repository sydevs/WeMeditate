class Article < ApplicationRecord
  extend FriendlyId

  # Extensions
  has_paper_trail
  translates :title, :slug
  friendly_id :title, use: :globalize

  # Associations
  belongs_to :category
  has_many :sections, -> { order(:order) }, dependent: :delete_all
  enum priority: { home_page: 2, high: 1, normal: 0, low: -1 }

  # Validations
  validates :title, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  
  # Scopes
  default_scope { order( priority: :desc ) }
  
  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
