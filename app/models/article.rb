class Article < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :title, :slug, :excerpt, :banner, :thumbnail
  friendly_id :title, use: :globalize

  # Associations
  belongs_to :category
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all
  mount_translated_uploader :banner, GenericImageUploader
  mount_translated_uploader :thumbnail, GenericImageUploader
  enum priority: { high: 1, normal: 0, low: -1 }

  # Validations
  validates :title, presence: true
  validates :excerpt, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( priority: :desc ) }
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }
  scope :published, -> { where.not(published_at: nil) }

  # Callbacks
  after_create :disable_drafts

  private
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
