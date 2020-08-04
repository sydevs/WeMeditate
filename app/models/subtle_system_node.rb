## SUBTLE SYSTEM NODE
# These represent chakras and channels that are a part of the subtle system.
# Each node is essentially a sub-page of the "subtle_system" StaticPage.
#
# There are a set number of subtle system nodes which are defined by the "role" enum,
# there should only ever be one subtle system node for each role.

class SubtleSystemNode < ApplicationRecord

  # Extensions
  extend FriendlyId
  audited
  translates :name, :slug, :excerpt, :metatags, :content, :draft, :state, :published_at
  friendly_id :name, use: [:slugged, :history]

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  enum role: {
    chakra_1: 1, chakra_2: 2, chakra_3: 3, chakra_3b: 4, chakra_4: 5, chakra_5: 6, chakra_6: 7, chakra_7: 8,
    channel_left: 9, channel_right: 10, channel_center: 11, kundalini: 12,
  }

  # Validations
  validates :name, presence: true
  validates :role, presence: true, uniqueness: true
  validates :excerpt, presence: true

  # Scopes
  default_scope { order(:role) }
  scope :q, -> (q) { with_translation.joins(:translations).where('subtle_system_node_translations.name ILIKE ?', "%#{q}%") if q.present? }

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
    SubtleSystemNode.roles.keys - SubtleSystemNode.pluck(:role)
  end

end
