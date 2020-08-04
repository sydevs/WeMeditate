## MEDITATION
# A meditation is a video, and some associated data which will take a user through a guided meditation experience.

class Meditation < ApplicationRecord

  # Extensions
  extend FriendlyId
  audited
  translates *%i[
    name slug metatags views popularity published_at state
    excerpt description
    horizontal_vimeo_id vertical_vimeo_id vimeo_metadata
  ]
  friendly_id :name, use: %i[slugged history]

  # Concerns
  include Viewable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_uploader :image, ImageUploader

  # Validations
  validates :name, presence: true
  validates :image, presence: true
  validates :excerpt, presence: true
  validates :duration_filter, presence: true
  # validates :goal_filters, presence: true, unless: :self_realization?
  validates :horizontal_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true
  validates :vertical_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true

  # Scopes
  # default_scope { order( id: :desc ) }
  scope :q, -> (q) { with_translation.joins(:translations).where('meditation_translations.name ILIKE ?', "%#{q}%") if q.present? }

  alias thumbnail image

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      includes(:translations, :duration_filter, goal_filters: :translations)
    when :content, :admin
      includes(:translations)
    end
  end

  # Calculate and return a few special types of meditaitons
  def self.get type, exclude: nil
    case type
    when :daily
      # A different random meditation every day
      seed = Date.today.to_time.to_i / (60 * 60 * 24) / 999999.0
      Meditation.connection.execute "SELECT setseed(#{seed})"
      Meditation.publicly_visible.order('RANDOM()').first
    when :trending
      # The meditation with the most views
      Meditation.publicly_visible.order('meditation_translations.popularity DESC').where.not(id: exclude).first
    when :self_realization
      Meditation.find_by(slug: I18n.translate('routes.self_realization', locale: Globalize.locale))
    else
      # A purely random meditation
      Meditation.publicly_visible.order('RANDOM()').first
    end
  end

  # There is one special type of meditation which is identified by having a certain slug
  def self_realization?
    slug == I18n.translate('routes.self_realization')
  end

  # A helper function to access the horizontal vs vertical vimeo metadata and symbolize the keys
  def vimeo_metadata type = nil
    return {} unless self[:vimeo_metadata].present?

    result = self[:vimeo_metadata].deep_symbolize_keys
    result = result[type.to_sym ] || {} if type.present?
    result
  end

end
