## ARTICLE
# An article is a dynamic page of content which form the "blog" feature of this website.
# Articles might be announcements, lifestyle posts, upcoming events, inspiring imagery or any other topic.
# Contrast this with StaticPage, SubtleSystemNode, or City which all have more specfic defined purposes.

## TYPE: PAGE
# An article is considered to be a "Page"
# This means it's content is defined by a collection of sections

class Article < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Drafts
  has_paper_trail ignore: [:published_at, :attachments]
  include RequireApproval

  # Extensions
  translates :title, :slug, :excerpt, :banner_uuid, :thumbnail_uuid, :metatags
  friendly_id :title, use: :globalize

  # Associations
  belongs_to :category
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all
  has_many :attachments, as: :page, inverse_of: :page, dependent: :delete_all
  enum priority: { high: 1, normal: 0, low: -1 }

  # Validations
  validates :title, presence: true
  validates :excerpt, presence: true
  validates :priority, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( priority: :desc, updated_at: :desc ) }
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }
  scope :published, -> { where.not(published_at: nil) }

  # Callbacks
  after_create :disable_drafts

  # Include everything necessary to render a preview of this model
  def self.includes_preview
    includes(:translations, category: :translations)
  end

  # Include everything necessary to render the full content of this model
  def self.includes_content
    includes(:attachments, :translations, category: :translations, sections: :translations)
  end

  # Shorthand for the article banner image file
  def banner
    attachments.find_by(uuid: banner_uuid)&.file
  end

  # Shorthand for the article thumbnail image file
  def thumbnail
    attachments.find_by(uuid: thumbnail_uuid)&.file
  end

  # Shorthand for the article video file
  def video
    attachments.find_by(uuid: video_uuid)&.file
  end

  # Returns a list of HTML metatags to be included on this article's page
  def get_metatags
    (metatags || {}).reverse_merge({
      'title' => title,
      'description' => excerpt,
    })
  end

  private
    # TODO: This is a temporary measure to disable the draft system until issues with draft integration can be resolved.
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
