## TREATMENT
# A treatment or technique is a video, and some description that describe a meditation technique.

class Treatment < ApplicationRecord

  # Extensions
  translates *%i[
    name slug metatags published_at draft state
    excerpt content thumbnail_id horizontal_vimeo_id vertical_vimeo_id
  ]

  # Concerns
  include Viewable
  include Contentable
  include Draftable
  include Stateable
  include Translatable # Should come after Publishable/Stateable

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
  scope :q, -> (q) { with_translation.joins(:translations).where('treatment_translations.name ILIKE ?', "%#{q}%") if q.present? }

  # Include everything necessary to render this model
  def self.preload_for _mode
    includes(:translations)
  end

  # Shorthand for the article thumbnail image file
  def thumbnail
    @thumbnail ||= media_files.find_by(id: thumbnail_id)&.file
  end

end
