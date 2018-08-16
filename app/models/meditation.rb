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

  def self.get type
    case type
    when :daily
      seed = Date.today.to_time.to_i / (60 * 60 * 24) / 999999.0
      puts "SEED _ #{seed}"
      Meditation.connection.execute "SELECT setseed(#{seed})"
      Meditation.order('RANDOM()').first
    when :trending
      Meditation.with_translations(I18n.locale).order('meditation_translations.views DESC').first
    else
      Meditation.order('RANDOM()').first
    end
  end

  def get_metatags
    (metatags || {}).reverse_merge({
      'title' => name,
      'description' => excerpt,
    })
  end
end
