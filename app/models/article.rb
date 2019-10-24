## ARTICLE
# An article is a dynamic page of content which form the "blog" feature of this website.
# Articles might be announcements, lifestyle posts, upcoming events, inspiring imagery or any other topic.
# Contrast this with StaticPage, or SubtleSystemNode which all have more specfic defined purposes.

class Article < ApplicationRecord

  # Extensions
  translates *%i[
    name slug metatags priority order
    draft published_at state
    excerpt banner_id thumbnail_id vimeo_id content
  ]

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  belongs_to :category
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :author, optional: true
  enum priority: { high: 1, normal: 0, low: -1, pinned: 999, hidden: -999 }
  enum author_type: { author: 0, artist: 1 }

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :priority, presence: true
  validates :order, presence: true, if: :published?
  validates :thumbnail_id, presence: true, if: :persisted?
  validates :vimeo_id, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_blank: true

  # Scopes
  scope :ordered, -> { order(order: :desc) }
  scope :upcoming, -> { published.where('article_translations.published_at >= ?', DateTime.now).order(published_at: :asc) }
  scope :q, -> (q) { with_translation.joins(:translations, category: :translations).where('article_translations.name ILIKE ? OR category_translations.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Callbacks
  before_validation :compute_order

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      includes(:translations, category: :translations)
    when :content
      includes(:media_files, :translations, category: :translations, author: :translations)
    when :admin
      includes(:media_files, :translations, category: :translations, author: :translations)
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

  private

    def compute_order
      return unless published?
      self[:published_at] ||= DateTime.now

      if priority == 'pinned'
        self[:order] = 2_147_483_647 # Set to max int
      elsif priority == 'hidden'
        self[:order] = -2_147_483_647 # Set to min int
      else
        self[:order] = published_at.to_i / (60 * 60 * 24) # Days since Unix epoch
      end

      self[:order] += 30 * self[:priority] if priority.present?
    end

end
