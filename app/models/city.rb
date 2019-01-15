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
  has_many :attachments, as: :page, inverse_of: :page, dependent: :delete_all

  # Validations
  validates :country, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :banner_uuid, presence: true
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
      includes(:attachments, :translations, sections: :translations)
    when :admin
      includes(:attachments, :translations)
    end
  end

  # Check if coordinates have been defined
  def has_coordinates?
    latitude.present? and longitude.present?
  end

  # Shorthand to access the banner file
  def banner
    image(banner_uuid)
  end

  # Shorthand to reference attachments to this model
  def image uuid
    attachments.find_by(uuid: uuid)&.file
  end

  # Returns a localized version of the city's country.
  def country_name
    I18nData.countries(I18n.locale)[self[:country]]
  end

  def full_name
    "#{name}, #{country_name}"
  end

  # Returns a list of default HTML metatags to be included on this city's page
  def default_metatags
    super.merge!({
      'title' => name,
      'og:type' => 'article',
      'og:title' => name,
      'og:image' => banner.url,
      'og:article:modified_time' => (published_at || updated_at).to_s(:db),
      'geo.placename' => name,
      'geo.position' => "#{latitude}; #{longitude}", # TODO: Determine if we should actually be defining this, since a city is larger than a set of coords.
      #'geo.region' => '' # TODO: Determine if we should define this. This is apparently the state/province code
      'twitter:card' => 'summary_large_image',
    })
  end

  # Returns a list of HTML metatags to be included on this city's page
  # `static_page` should be a StaticPage model, and provides default metatags
  def get_metatags static_page = nil
    result = (self[:metatags] || {}).reverse_merge(default_metatags)
    result = static_page.get_metatags.merge(result) if static_page.present?
    result
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
