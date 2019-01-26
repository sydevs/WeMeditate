## ARTICLE
# An article is a dynamic page of content which form the "blog" feature of this website.
# Articles might be announcements, lifestyle posts, upcoming events, inspiring imagery or any other topic.
# Contrast this with StaticPage, SubtleSystemNode, or City which all have more specfic defined purposes.

## TYPE: PAGE
# An article is considered to be a "Page"
# This means it's content is defined by a collection of sections

class Article < ApplicationRecord
  extend FriendlyId
  include Draftable

  # Extensions
  translates :name, :slug, :excerpt, :banner_id, :thumbnail_id, :video_id, :metatags, :draft
  friendly_id :name, use: :globalize

  # Associations
  belongs_to :category
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all, autosave: true
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  enum priority: { high: 1, normal: 0, low: -1 }

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :priority, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( priority: :desc, updated_at: :desc ) }
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }
  scope :published, -> { where.not(published_at: nil) }
  scope :q, -> (q) { joins(:translations, category: :translations).where('article_translations.name ILIKE ? OR category_translations.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Callbacks
  after_create :disable_drafts

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      includes(:translations, category: :translations)
    when :content
      includes(:media_files, :translations, category: :translations, sections: :translations)
    when :admin
      includes(:media_files, :translations, category: :translations)
    end
  end

  # Shorthand for the article banner image file
  def banner
    media_files.find_by(id: banner_id)&.file
  end

  # Shorthand for the article thumbnail image file
  def thumbnail
    media_files.find_by(id: thumbnail_id)&.file
  end

  # Shorthand for the article video file
  def video
    media_files.find_by(id: video_id)&.file
  end

  private
    # TODO: This is a temporary measure to disable the draft system until issues with draft integration can be resolved.
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
