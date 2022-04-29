## STATIC PAGE
# This represents a static webpage on the website, such as the Front Page, the Articles index, the Contact,
# or certain other pages which will not be removed from the site in the foreseeable future.
# This model allows us to define the content for those static pages in the CMS instead of hardcoding them in HTML/Slim files.
#
# There are a set number of static pages which are defined by the "role" enum, there should only ever be one static page for each role.

class StaticPage < ApplicationRecord

  ROLES = {
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5, privacy: 7,
    articles: 10, treatments: 11, tracks: 12, meditations: 13, classes: 14, streams: 15,
  }.freeze

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
  enum role: ROLES.clone.merge(custom: 99)

  # Validations
  validates :name, presence: true
  validates :role, presence: true
  validates :role, uniqueness: true, unless: :custom?

  # Scopes
  default_scope { order(:role) }
  scope :q, -> (q) { with_translation.joins(:translations).where('static_page_translations.name ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }
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
    StaticPage.roles.keys - [:custom] - StaticPage.where.not(role: :custom).pluck(:role)
  end

  def slug
    I18n.translate("routes.#{role}")
  end

  def self.find_by_slug slug
    # Simply fetch all previews and store them, because we know that every page load will require almost every static page preview to generate the navigation
    @@static_page_lookups ||= {}

    unless @@static_page_lookups[I18n.locale].present?
      @@static_page_lookups[I18n.locale] = {}
      I18n.translate('routes').each do |role, translated_slug|
        next unless ROLES.has_key?(role)
        @@static_page_lookups[I18n.locale][translated_slug] = role.to_sym
      end
    end

    role = @@static_page_lookups[I18n.locale][slug]
    find_by_role(role)
  end

  # Fetch a preview of the static page for a given role
  def self.preview role
    # Simply fetch all previews and store them, because we know that every page load will require almost every static page preview to generate the navigation
    unless defined? @@static_page_previews
      @@static_page_previews = StaticPage.preload_for(:preview).special.index_by(&:role) # rubocop:disable Style/ClassVars
    end

    @@static_page_previews[role.to_s]
  end

end
