## STATIC PAGE
# This represents a static webpage on the website, such as the Front Page, the Articles index, the Contact,
# or certain other pages which will not be removed from the site in the foreseeable future.
# This model allows us to define the content for those static pages in the CMS instead of hardcoding them in HTML/Slim files.
#
# There are a set number of static pages which are defined by the "role" enum, there should only ever be one static page for each role.

class StaticPage < ApplicationRecord

  extend FriendlyId
  include HasContent
  include Draftable

  # Extensions
  translates :name, :slug, :metatags, :content, :draft, :published_at
  friendly_id :name, use: :globalize

  # Associations
  enum role: {
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5, self_realization: 6, privacy: 7,
    articles: 10, treatments: 11, tracks: 12, meditations: 13, classes: 14,
  }

  # Validations
  validates :name, presence: true
  validates :role, presence: true, uniqueness: true

  # Scopes
  default_scope { order(:role) }
  scope :needs_translation, -> (user) { where.not(id: with_translations(I18n.locale).pluck(:id)).where(original_locale: user.available_languages) }
  scope :q, -> (q) { joins(:translations).where('static_page_translations.name ILIKE ? OR role ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

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
    StaticPage.roles.keys - StaticPage.pluck(:role)
  end

end
