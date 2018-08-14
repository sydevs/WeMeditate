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

  def get_metatags
    metatags.merge({
      'title' => name,
      'description' => excerpt,
    })
  end

end
