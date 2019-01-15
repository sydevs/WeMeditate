## MEDITATION
# A meditation is a video, and some associated data which will take a user through a guided meditation experience.

# TYPE: RESOURCE
# A meditation is considered to be a "Resource".
# This means it is a standalone model, but it's content is specialized, and not defined using a collection of page sections

class Meditation < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :video, :metatags, :views
  friendly_id :name, use: :globalize

  # Associations
  has_and_belongs_to_many :goal_filters
  belongs_to :duration_filter
  mount_translated_uploader :video, VideoUploader
  mount_uploader :image, GenericImageUploader

  # Validations
  validates :name, presence: true
  validates :image, presence: true
  validates :video, presence: true
  validates :duration_filter, presence: true
  validates :goal_filters, presence: true

  # Scopes
  #default_scope { order( id: :desc ) }
  scope :q, -> (q) { joins(:translations).where('meditation_translations.name ILIKE ?', "%#{q}%") if q.present? }

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
      #puts "SEED _ #{seed}"
      Meditation.connection.execute "SELECT setseed(#{seed})"
      Meditation.order('RANDOM()').first
    when :trending
      # The meditation with the most views
      Meditation.with_translations(I18n.locale).order('meditation_translations.views DESC').first
    else
      # A purely random meditation
      Meditation.order('RANDOM()').first
    end
  end

  # Returns a list of default HTML metatags to be included on this meditation's page
  def default_metatags
    super.merge!({
      'title' => name,
      'description' => excerpt,
      'og:type' => 'video.other',
      'og:title' => name,
      'og:description' => excerpt,
      'og:image' => image.url,
      'og:locale:alternate' => translated_locales,
      #'og:video:duration' => '', # TODO: Define this
      'og:video:release_date' => created_at.to_s(:db),
      'twitter:card' => 'player',
      #'twitter:player:url' => '', # TODO: We must have an embeddable video iframe to reference here.
      #'twitter:player:width' => '',
      #'twitter:player:height' => '',
    })
  end

  # Returns a list of HTML metatags to be included on this meditation's page
  def get_metatags
    (self[:metatags] || {}).reverse_merge(default_metatags)
  end
end
