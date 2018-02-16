class StaticPage < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :title, :slug
  friendly_id :title, use: :globalize

  # Associations
  enum role: [
    :home, :contact, :shri_mataji, :subtle_system, :sahaja_yoga, :kundalini,
    :chakra_1, :chakra_2, :chakra_3, :chakra_3b, :chakra_4, :chakra_5, :chakra_6, :chakra_7,
    :channel_left, :channel_right, :channel_center
  ]
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all

  # Validations
  validates :title, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order(:role) }
  scope :untranslated, -> { joins(:translations).where.not(static_page_translations: { locale: I18n.locale }) }


  def self.available_roles
    StaticPage.roles.keys - StaticPage.pluck(:role)
  end

  def generate_default_sections!
    case role.to_sym
    when :shri_mataji
      ensure_special_section_exists! :try_meditation
      ensure_special_section_exists! :awards
    when :subtle_system
      ensure_special_section_exists! :subtle_system
    end
  end

  def ensure_special_section_exists! format
    unless sections.exists?(content_type: :special, format: format)
      sections.new(content_type: :special, format: format, language: I18n.locale)
    end
  end

  def self.new_special format
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

end
  