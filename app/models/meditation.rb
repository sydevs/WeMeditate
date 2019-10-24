## MEDITATION
# A meditation is a video, and some associated data which will take a user through a guided meditation experience.

class Meditation < ApplicationRecord

  # Extensions
  translates *%i[
    name slug metatags views popularity
    draft published_at state
    thumbnail_id excerpt description
    horizontal_vimeo_id vertical_vimeo_id vimeo_metadata
  ]

  # Concerns
  include Viewable
  include Draftable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all
  has_and_belongs_to_many :goal_filters, draftable: true # This special `draftable` flag is necessary for has_many associations.
  belongs_to :duration_filter
  # mount_uploader :image, ImageUploader

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :duration_filter, presence: true
  # validates :goal_filters, presence: true
  validates :thumbnail_id, presence: true, if: :persisted?
  validates :horizontal_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true
  validates :vertical_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true

  # Scopes
  # default_scope { order( id: :desc ) }
  scope :q, -> (q) { with_translation.joins(:translations).where('meditation_translations.name ILIKE ?', "%#{q}%") if q.present? }

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
  def self.get type
    case type
    when :daily
      # A different random meditation every day
      seed = Date.today.to_time.to_i / (60 * 60 * 24) / 999999.0
      Meditation.connection.execute "SELECT setseed(#{seed})"
      Meditation.publicly_visible.order('RANDOM()').first
    when :trending
      # The meditation with the most views
      Meditation.publicly_visible.order('meditation_translations.popularity DESC').first
    when :self_realization
      Meditation.find_by(slug: I18n.translate('routes.self_realization'))
    else
      # A purely random meditation
      Meditation.publicly_visible.order('RANDOM()').first
    end
  end

  def self_realization?
    slug == I18n.translate('routes.self_realization')
  end

  def vimeo_metadata type = nil
    return {} unless self[:vimeo_metadata].present?
    result = self[:vimeo_metadata].deep_symbolize_keys
    result = result[type.to_sym ] || {} if type.present?
    result
  end

  # Shorthand for the meditation image file
  def thumbnail
    media_files.find_by(id: thumbnail_id)&.file
  end

end
