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

  # Include everything necessary to render a preview of this model
  def self.includes_preview
    includes(:translations)
  end

  # Include everything necessary to render the full content of this model
  def self.includes_content
    includes(:translations)
  end

  # Returns a list of HTML metatags to be included on this static page
  def get_metatags
    (metatags || {}).reverse_merge({
      'title' => name,
      'description' => excerpt,
    })
  end

end
