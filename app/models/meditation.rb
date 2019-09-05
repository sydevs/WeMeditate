## MEDITATION
# A meditation is a video, and some associated data which will take a user through a guided meditation experience.

class Meditation < ApplicationRecord

  extend FriendlyId
  extend CarrierwaveGlobalize
  include Translatable

  # Extensions
  translates *%i[
    name slug metatags views published_at published
    excerpt description horizontal_vimeo_id vertical_vimeo_id
  ]
  friendly_id :name, use: :globalize

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_uploader :image, ImageUploader

  # Validations
  validates :name, presence: true
  validates :image, presence: true
  validates :excerpt, presence: true
  validates :duration_filter, presence: true
  validates :goal_filters, presence: true
  validates :horizontal_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true
  validates :vertical_vimeo_id, presence: true, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_nil: true

  # Scopes
  # default_scope { order( id: :desc ) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :q, -> (q) { with_translations(I18n.locale).joins(:translations).where('meditation_translations.name ILIKE ?', "%#{q}%") if q.present? }

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
  def self.get type
    case type
    when :daily
      # A different random meditation every day
      seed = Date.today.to_time.to_i / (60 * 60 * 24) / 999999.0
      Meditation.connection.execute "SELECT setseed(#{seed})"
      Meditation.published.order('RANDOM()').first
    when :trending
      # The meditation with the most views
      Meditation.published.order('meditation_translations.views DESC').first
    when :self_realization
      Meditation.find_by(slug: I18n.translate('routes.self_realization'))
    else
      # A purely random meditation
      Meditation.published.order('RANDOM()').first
    end
  end

  def self_realization?
    slug == I18n.translate('routes.self_realization')
  end

end
