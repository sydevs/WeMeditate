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

  # Callbacks
  after_create :disable_drafts

  def has_coordinates?
    latitude.present? and longitude.present?
  end

  def banner
    image(banner_uuid)
  end

  def image uuid
    attachments.find_by(uuid: uuid)&.file
  end

  def country_name
    I18nData.countries(I18n.locale)[self[:country]]
  end

  def full_name
    "#{name}, #{country_name}"
  end

  def get_metatags
    metatags.merge({
      'title' => name,
    })
  end

  def generate_default_sections!
    sections.new label: 'What to Expect', content_type: :text, format: :box_over_image
    sections.new label: 'Testimonial', content_type: :video
  end

  private
    def disable_drafts
      update_column :published_at, DateTime.now
    end
end
