## ARTIST
# An author is the writer

# TYPE: RESOURCE
# An author is considered to be a "Filter", which is used to categorize the Track model

class Author < ApplicationRecord
  
  # Extensions
  audited
  translates :name, :title, :description, :state, :published_at

  # Concerns
  include Stateable
  include Translatable # Should come after Publishable/Stateable

  # Associations
  belongs_to :user, required: false
  has_many :articles, counter_cache: true
  mount_uploader :image, AuthorImageUploader
  
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true
  validates :years_meditating, numericality: { only_integer: true }, allow_nil: true
  validates :description, presence: true
  validates :image, presence: true

  # Scope
  scope :q, -> (q) { where('name ILIKE ?', "%#{q}%") if q.present? }

  def country_name
    I18n.translate(country_code.downcase, scope: 'author.countries', default: country_code)
  end

end
  