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

  alias thumbnail image

  # Include everything necessary to render a preview of this model
  def self.includes_preview
    includes(:translations, :duration_filter, goal_filters: :translations)
  end

  # Include everything necessary to render the full content of this model
  def self.includes_content
    includes(:translations)
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

  # Returns a list of HTML metatags to be included on this meditation's page
  def get_metatags
    (metatags || {}).reverse_merge({
      'title' => name,
      'description' => excerpt,
    })
  end
end
