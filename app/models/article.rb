class Article < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :title, :slug
  friendly_id :title, use: :globalize

  # Associations
  belongs_to :category
  enum priority: { high: 1, normal: 0, low: -1 }
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all

  # Validations
  validates :title, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( priority: :desc ) }
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

end
