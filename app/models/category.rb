## CATEGORY
# Articles are placed into different categories which are defined by this model.

# TYPE: FILTER
# An category is considered to be a "Filter", which is used to categorize the Article model

class Category < ApplicationRecord

  # Extensions
  extend FriendlyId
  translates :name, :slug, :published_at, :published
  friendly_id :name, use: :globalize

  # Concerns
  include Publishable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_many :articles, counter_cache: true

  # Validations
  validates :name, presence: true, uniqueness: true

  # Scopes
  default_scope { order(:order) }
  scope :q, -> (q) { with_translation.joins(:translations).where('category_translations.name ILIKE ?', "%#{q}%") if q.present? }

  def self.has_content
    joins(articles: :translations).where({
      article_translations: { published: true, locale: I18n.locale },
    }).uniq
  end

  def preload_for mode
    case mode
    when :preview, :content, :admin
      includes(:translations)
    end
  end

end
