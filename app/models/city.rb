## CITY
# This represents a real world city where free meditation classes are offered.

class City < ApplicationRecord
  extend FriendlyId

  # Drafts
  has_paper_trail ignore: [:published_at]
  include RequireApproval

  # Extensions
  translates :name, :slug, :metatags
  friendly_id :name, use: :globalize

  # Associations
  has_many :sections, -> { order(:order) }, as: :page, inverse_of: :page, dependent: :delete_all
  has_many :media_files, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :country, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :banner_id, presence: true
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
  enum country: I18nData.countries.keys

  # Scopes
  scope :untranslated, -> { joins(:translations).where.not(article_translations: { locale: I18n.locale }) }
  scope :q, -> (q) { joins(:translations).where('city_translations.name ILIKE ?', "%#{q}%") if q.present? }
  #scope :q, -> (q) { joins(:translations).where('city_translations.name ILIKE ? OR country ILIKE ?', "%#{q}%", "%#{q}%") if q.present? }

  # Callbacks
  after_create :disable_drafts

  # Include everything necessary to render this model
  def self.preload_for mode
    case mode
    when :preview
      includes(:translations)
    when :content
      includes(:media_files, :translations, sections: :translations)
    when :admin
      includes(:media_files, :translations)
    end
  end

  # Check if coordinates have been defined
  def has_coordinates?
    latitude.present? and longitude.present?
  end

  # Shorthand to access the banner file
  def banner
    media_files.find_by(id: banner_id)&.file
  end

  # Returns a localized version of the city's country.
  def country_name
    I18nData.countries(I18n.locale)[self[:country]]
  end

  def full_name
    "#{name}, #{country_name}"
  end

  # Generates some default sections which should be included on every city page.
  def generate_default_sections!
    sections.new label: I18n.t('misc.default_sections.what_to_expect'), content_type: :text, format: :box_over_image
    sections.new label: I18n.t('misc.default_sections.testimonials'), content_type: :video
  end

  private
    # TODO: This is a temporary measure to disable the draft system until issues with draft integration can be resolved.
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
