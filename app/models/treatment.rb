## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

# TYPE: RESOURCE
# A meditation is considered to be a "Resource".
# This means it is a standalone model, but it's content is specialized, and not defined using a collection of page sections

class Treatment < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :content, :thumbnail, :video, :metatags
  friendly_id :name, use: :globalize

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :content, presence: true
  validates :thumbnail, presence: true
  validates :video, presence: true

  mount_translated_uploader :video, VideoUploader
  mount_translated_uploader :thumbnail, GenericImageUploader

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(treatment_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for mode
    includes(:translations)
  end

  # Returns a list of default HTML metatags to be included on this treatment's page
  def default_metatags
    super.merge!({
      'title' => name,
      'description' => excerpt,
      'og:type' => 'video.other',
      'og:title' => name,
      'og:description' => excerpt,
      'og:image' => image.url,
      #'og:video:duration' => '', # TODO: Define this
      'og:video:release_date' => created_at.to_s(:db),
      'twitter:card' => 'player',
      #'twitter:player:url' => '', # TODO: We must have an embeddable video iframe to reference here.
      #'twitter:player:width' => '',
      #'twitter:player:height' => '',
    })
  end

  # Returns a list of HTML metatags to be included on this treatment's page
  def get_metatags
    (self[:metatags] || {}).reverse_merge(default_metatags)
  end

end
