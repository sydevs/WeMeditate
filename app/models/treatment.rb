## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

class Treatment < ApplicationRecord

  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates :name, :slug, :excerpt, :content, :thumbnail, :horizontal_vimeo_id, :vertical_vimeo_id, :metatags, :published
  friendly_id :name, use: :globalize

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :content, presence: true
  validates :thumbnail, presence: true
  validates :horizontal_vimeo_id, presence: true
  validates :vertical_vimeo_id, presence: true

  mount_translated_uploader :thumbnail, TreatmentImageUploader

  # Scopes
  default_scope { order(:order) }
  scope :untranslated, -> { where.not(id: with_translations(I18n.locale).pluck(:id)) }
  scope :published, -> { joins(:translations).where(published: true, treatment_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for _mode
    includes(:translations)
  end

end
