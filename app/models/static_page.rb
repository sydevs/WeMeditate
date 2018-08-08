class StaticPage < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :title, :slug
  friendly_id :title, use: :globalize

  # Associations
  enum role: {
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5,
    treatments: 11, tracks: 12, meditations: 13, country: 14, world: 15, city: 16,
  }
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all
  has_many :attachments, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :title, presence: true
  validates :role, presence: true, uniqueness: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order(:role) }
  scope :untranslated, -> { joins(:translations).where.not(static_page_translations: { locale: I18n.locale }) }

  # Callbacks
  after_create :disable_drafts

  def self.available_roles
    StaticPage.roles.keys - StaticPage.pluck(:role)
  end

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

  def ensure_special_section_exists! format, attrs = {}
    unless sections.exists?(content_type: :special, format: format)
      sections.new(attrs.merge!(content_type: :special, format: format))
    end
  end

  private
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
