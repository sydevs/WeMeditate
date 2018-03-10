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
    home: 0, about: 1, contact: 2, shri_mataji: 3, subtle_system: 4, sahaja_yoga: 5, kundalini: 6,
    chakra_1: 7, chakra_2: 8, chakra_3: 9, chakra_3b: 10, chakra_4: 11, chakra_5: 12, chakra_6: 13, chakra_7: 14,
    channel_left: 15, channel_right: 16, channel_center: 17
  }
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
end
  