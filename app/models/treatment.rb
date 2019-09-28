## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

class Treatment < ApplicationRecord

  extend CarrierwaveGlobalize
  extend FriendlyId
  include HasContent
  include Draftable
  include Translatable

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
  validates :thumbnail_id, presence: true, if: :persisted?
  validates :horizontal_vimeo_id, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_blank: true, unless: :vertical_vimeo_id?
  validates :horizontal_vimeo_id, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, presence: true, if: :vertical_vimeo_id?
  validates :vertical_vimeo_id, numericality: { less_than: MAX_INT, only_integer: true, message: I18n.translate('admin.messages.invalid_vimeo_id') }, allow_blank: true

  # Scopes
  default_scope { order(:order) }
  scope :published, -> { with_translations(I18n.locale).where(published: true) }
  scope :not_published, -> { with_translations(I18n.locale).where.not(published: true) }
  scope :q, -> (q) { with_translations(I18n.locale).joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for _mode
    includes(:translations)
  end

  # Shorthand for the article thumbnail image file
  def thumbnail
    @thumbnail ||= media_files.find_by(id: thumbnail_id)&.file
  end

end
