class SubtleSystemNode < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt
  friendly_id :name, use: :globalize

  # Associations
  enum role: {
    chakra_1: 1, chakra_2: 2, chakra_3: 3, chakra_3b: 4, chakra_4: 5, chakra_5: 6, chakra_6: 7, chakra_7: 8,
    channel_left: 9, channel_right: 10, channel_center: 11, kundalini: 12,
  }
  has_many :sections, -> { order(:order) }, as: :page, dependent: :delete_all

  # Validations
  validates :name, presence: true
  validates :role, presence: true, uniqueness: true
  validates :excerpt, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  # Scopes
  default_scope { order( :role ) }
  scope :untranslated, -> { joins(:translations).where.not(subtle_system_node_translations: { locale: I18n.locale }) }


  def self.available_roles
    SubtleSystemNode.roles.keys - SubtleSystemNode.pluck(:role)
  end

  def generate_default_sections!
    sections.new label: 'Chakra Overview', content_type: :text, format: :columns
    sections.new label: 'In Daily Life', content_type: :text, format: :box_over_image
    sections.new content_type: :special, format: :treatments
    sections.new label: 'Shri Mataji\'s Video', content_type: :video
    sections.new label: 'Ancient Wisdom', content_type: :text, format: :ancient_wisdom
  end

end
