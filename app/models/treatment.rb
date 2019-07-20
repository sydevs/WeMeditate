## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

class Treatment < ApplicationRecord

  extend FriendlyId
  extend CarrierwaveGlobalize

  # Extensions
  translates *%i[
    name slug metatags published_at published
    excerpt content thumbnail horizontal_vimeo_id vertical_vimeo_id
  ]
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
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :untranslated, -> { where.not(original_locale: I18n.locale, id: published.pluck(:id)) }
  scope :q, -> (q) { joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for _mode
    includes(:translations)
  end

end
