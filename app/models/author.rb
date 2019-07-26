## ARTIST
# An author is the writer

# TYPE: RESOURCE
# An author is considered to be a "Filter", which is used to categorize the Track model

class Author < ApplicationRecord

  # Extensions
  translates :title, :description

  # Associations
  belongs_to :user, required: false
  has_many :articles
  mount_uploader :image, AuthorImageUploader
  
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :years_meditating, numericality: { only_integer: true }, allow_nil: true
  validates :description, presence: true
  validates :image, presence: true

  # Scope
  scope :untranslated, -> { where.not(id: with_translations(I18n.locale).pluck(:id)) }
  scope :q, -> (q) { where('name ILIKE ?', "%#{q}%") if q.present? }

end
  