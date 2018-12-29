## SUBTLE SYSTEM NODE
# These represent chakras and channels that are a part of the subtle system.
# Each node is essentially a sub-page of the "subtle_system" StaticPage.
#
# There are a set number of subtle system nodes which are defined by the "role" enum,
# there should only ever be one subtle system node for each role.

## TYPE: PAGE
# An article is considered to be a "Page"
# This means it's content is defined by a collection of sections

class SubtleSystemNode < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :metatags
  friendly_id :name, use: :globalize

  # Associations
  enum role: {
    chakra_1: 1, chakra_2: 2, chakra_3: 3, chakra_3b: 4, chakra_4: 5, chakra_5: 6, chakra_6: 7, chakra_7: 8,
    channel_left: 9, channel_right: 10, channel_center: 11, kundalini: 12,
  }
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all
  has_many :attachments, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :name, presence: true
  validates :role, presence: true, uniqueness: true
  validates :excerpt, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( :role ) }
  scope :untranslated, -> { joins(:translations).where.not(subtle_system_node_translations: { locale: I18n.locale }) }

  # Include everything necessary to render a preview of this model
  def self.includes_preview
    includes(:translations)
  end

  # Include everything necessary to render the full content of this model
  def self.includes_content
    if mode == :admin
      includes(:attachments, :translations)
    else
      includes(:attachments, :translations, sections: :translations)
    end
  end

  # Returns a list of which roles don't yet have a database representation.
  def self.available_roles
    SubtleSystemNode.roles.keys - SubtleSystemNode.pluck(:role)
  end

  # Returns a list of HTML metatags to be included on this static page
  def get_metatags
    (metatags || {}).reverse_merge({
      'title' => name,
      'description' => excerpt,
    })
  end

  # Generates sections which should be included on every subtle system page.
  def generate_default_sections!
    sections.new label: 'Chakra Overview', content_type: :text, format: :columns
    sections.new label: 'In Daily Life', content_type: :text, format: :box_over_image
    sections.new content_type: :special, format: :treatments
    sections.new label: 'Shri Mataji\'s Video', content_type: :video
    sections.new label: 'Ancient Wisdom', content_type: :text, format: :ancient_wisdom
  end

  # Generates sections which MUST be included on every subtle system node page.
  def generate_required_sections!
    ensure_special_section_exists! :treatments
  end

  # Checks to see if a special section exists for this page, and creates it if it doesn't.
  def ensure_special_section_exists! format
    unless sections.exists?(content_type: :special, format: format)
      sections.new(content_type: :special, format: format)
    end
  end

end
