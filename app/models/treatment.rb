class Treatment < ApplicationRecord
  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :content, :thumbnail, :video
  friendly_id :name, use: :globalize

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  mount_translated_uploader :video, VideoUploader
  mount_translated_uploader :thumbnail, GenericImageUploader

  # Scopes
  default_scope { order( :order ) }
  scope :untranslated, -> { joins(:translations).where.not(treatment_translations: { locale: I18n.locale }) }

end
