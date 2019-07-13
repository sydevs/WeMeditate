## ARTICLE
# An article is a dynamic page of content which form the "blog" feature of this website.
# Articles might be announcements, lifestyle posts, upcoming events, inspiring imagery or any other topic.
# Contrast this with StaticPage, or SubtleSystemNode which all have more specfic defined purposes.

class Article < ApplicationRecord

  extend FriendlyId
  include HasContent
  include Draftable

  # Extensions
  translates :name, :slug, :excerpt, :banner_id, :thumbnail_id, :vimeo_id, :metatags, :content, :draft, :published_at, :published
  friendly_id :name, use: :globalize

  # Associations
  belongs_to :category
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  belongs_to :owner, class_name: 'User', optional: true
  enum priority: { high: 1, normal: 0, low: -1 }

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :priority, presence: true
  validates :thumbnail_id, presence: true, unless: :new_record?

  # Scopes
  default_scope { order(priority: :desc, updated_at: :desc) } # TODO: This should be ordered by published_at instead?
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }
  scope :published, -> { joins(:translations).where(published: true, article_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations, category: :translations).where('article_translations.name ILIKE ? OR category_translations.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      includes(:translations, category: :translations)
    when :content
      includes(:media_files, :translations, category: :translations)
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
    media_files.find_by(id: vimeo_id)&.file
  end

end
