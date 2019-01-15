## STATIC PAGE
# This represents a static webpage on the website, such as the Front Page, the Articles index, the Contact,
# or certain other pages which will not be removed from the site in the foreseeable future.
# This model allows us to define the content for those static pages in the CMS instead of hardcoding them in HTML/Slim files.
#
# There are a set number of static pages which are defined by the "role" enum, there should only ever be one static page for each role.

## TYPE: PAGE
# An article is considered to be a "Page"
# This means it's content is defined by a collection of sections

class StaticPage < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :name, :slug, :metatags
  friendly_id :name, use: :globalize

  # Associations
  enum role: {
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5,
    articles: 10, treatments: 11, tracks: 12, meditations: 13, country: 14, world: 15, city: 16,
  }
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all
  has_many :attachments, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :name, presence: true
  validates :role, presence: true, uniqueness: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order(:role) }
  scope :untranslated, -> { joins(:translations).where.not(static_page_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations).where('static_page_translations.name ILIKE ? OR role ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Callbacks
  after_create :disable_drafts

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      joins(:translations)
    when :content
      includes(:attachments, :translations, sections: :translations)
    when :admin
      includes(:attachments, :translations)
    end
  end

  # Returns a list of which roles don't yet have a database representation.
  def self.available_roles
    StaticPage.roles.keys - StaticPage.pluck(:role)
  end

  # Certain static pages must include some specific special sections
  # This function generates those sections if they don't already exist.
  def generate_required_sections!
    case role.to_sym
    when :home
      ensure_special_section_exists! :banner, { extra: { 'banner_style' => 'front_page' } }
    when :shri_mataji
      ensure_special_section_exists! :try_meditation
    when :treatments
      ensure_special_section_exists! :banner, { extra: { 'banner_style' => 'treatments_page' } }
    when :country
      ensure_special_section_exists! :country
    when :city
      ensure_special_section_exists! :banner, { extra: { 'banner_style' => 'city_page' } }
      ensure_special_section_exists! :city_sections
      ensure_special_section_exists! :venue_map
      ensure_special_section_exists! :venue_registration
      ensure_special_section_exists! :local_contacts
    when :subtle_system
      ensure_special_section_exists! :subtle_system
    when :meditations
      ensure_special_section_exists! :featured_meditations
      ensure_special_section_exists! :custom_meditation
    end
  end

  # Checks to see if a special section exists for this page, and creates it if it doesn't.
  def ensure_special_section_exists! format, attrs = {}
    unless sections.exists?(content_type: :special, format: format)
      sections.new(attrs.merge!(content_type: :special, format: format))
    end
  end

  private
    # TODO: This is a temporary measure to disable the draft system until issues with draft integration can be resolved.
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
