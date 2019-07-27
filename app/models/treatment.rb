## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

class Treatment < ApplicationRecord

  extend CarrierwaveGlobalize
  extend FriendlyId
  include HasContent
  include Draftable

  # Extensions
  translates *%i[
    name slug metatags published_at published draft
    excerpt content thumbnail_id horizontal_vimeo_id vertical_vimeo_id
  ]
  friendly_id :name, use: :globalize

  # Associations
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :name, presence: true
  validates :excerpt, presence: true
  validates :content, presence: true
  validates :thumbnail, presence: true
  validates :horizontal_vimeo_id, presence: true
  validates :vertical_vimeo_id, presence: true

  # Scopes
  default_scope { order(:order) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :needs_translation, -> (user) { where.not(original_locale: I18n.locale, id: published.pluck(:id)).where(original_locale: user.available_languages) }
  scope :q, -> (q) { joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for _mode
    includes(:translations)
  end

  # Shorthand for the article thumbnail image file
  def thumbnail
    media_files.find_by(id: thumbnail_id)&.file
  end

end
