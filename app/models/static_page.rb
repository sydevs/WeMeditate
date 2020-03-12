## STATIC PAGE
# This represents a static webpage on the website, such as the Front Page, the Articles index, the Contact,
# or certain other pages which will not be removed from the site in the foreseeable future.
# This model allows us to define the content for those static pages in the CMS instead of hardcoding them in HTML/Slim files.
#
# There are a set number of static pages which are defined by the "role" enum, there should only ever be one static page for each role.

class StaticPage < ApplicationRecord

  # Extensions
  audited
  translates :name, :slug, :metatags, :content, :draft, :published_at, :state

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  enum role: {
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5, privacy: 7,
    articles: 10, treatments: 11, tracks: 12, meditations: 13, classes: 14,
    custom: 99,
  }

  # Validations
  validates :name, presence: true
  validates :role, presence: true
  validates :role, uniqueness: true, unless: :custom?

  # Scopes
  default_scope { order(:role) }
  scope :q, -> (q) { with_translation.joins(:translations).where('static_page_translations.name ILIKE ? OR role ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }
  scope :special, -> { where.not(role: :custom) }
  
  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      joins(:translations)
    when :content
      includes(:media_files, :translations)
    when :admin
      includes(:media_files, :translations)
    end
  end

  # Returns a list of which roles don't yet have a database representation.
  def self.available_roles
    StaticPage.roles.keys - StaticPage.where.not(role: :custom).pluck(:role)
  end

end
