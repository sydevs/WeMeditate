## SECTION
# A section represents a block of text, an image, or some interactive element that should be rendered on the associated page.

# TYPE: SECTION
# The Section model is a unique kind of model that is used by all "Page"-type models to build their content.

class Section < ApplicationRecord
  include Draftable

  # Extensions
  translates :label, :title, :subtitle, :text, :quote, :credit, :action, :url, :extra, :draft

  attribute :label
  attribute :title
  attribute :subtitle
  attribute :text
  attribute :quote
  attribute :credit
  attribute :action
  attribute :url
  attribute :extra
  attribute :draft
  alias name label

  # Associations
  belongs_to :page, polymorphic: true, touch: true
  has_many :media_files, through: :page
  enum content_type: { text: 0, image: 1, video: 2, action: 5, textbox: 6, structured: 7, special: 8 }
  enum visibility_type: { worldwide: 0, only_certain_countries: 1, except_certain_countries: 2 }

  # Validations
  validates :content_type, presence: true
  validates :format, presence: true

  # Scopes
  default_scope { order(:order) }
  #scope :q, -> (q) { joins(:translations).where('label ILIKE ?', "%#{q}%") if q.present? }

  # Formats - A list of recognized non-special formats, which will be shown in the CMS
  FORMATS = {
    text: [:just_text, :just_quote, :with_quote, :with_image],
    image: [:fit_container_width, :fit_page_width, :image_gallery],
    video: [:single, :video_gallery],
    action: [:signup, :button],
    textbox: [:lefthand, :righthand, :overtop, :ancient_wisdom],
    structured: [:grid, :columns],
  }

  # Check whether this section indicates the start of a new chapter for the article
  def chapter_start?
    content_type == 'text' and title.present?
  end

  # Return the string that should be used as an HTML # anchor for this chapter
  def chapter_slug
    title&.parameterize
  end

  # Is this a special section?
  def special?
    content_type == 'special'
  end

  # An accessor for the `extra` json field, which allows a default to be specified
  def extra_attr key, default = nil
    if extra.present? and extra.is_a? Hash and extra.key? key
      extra[key]
    else
      default
    end
  end

  def name
    if label.present?
      label
    elsif special?
      format_name
    else
      I18n.translate "activerecord.attributes.section.labels.#{format}"
    end
  end

  def format_name
    format.present? ? I18n.translate("activerecord.attributes.section.formats.#{format}") : nil
  end

  def content_type_name
    content_type.present? ? I18n.translate("activerecord.attributes.section.content_types.#{content_type}") : nil
  end

  # Shorthand to access the main image associate with this section, if there is one.
  def image id = nil
    id = extra_attr('image_id') if id.nil?
    page.media_files.find_by(id: id)&.file
  end

  # Shorthand to access the main video associate with this section, if there is one.
  def video id = nil
    id = extra_attr('video_id') if id.nil?
    page.media_files.find_by(id: id)&.file
  end

  # Shorthand to access the decoration configuration for this section
  def decorations
    @decorations ||= extra_attr('decorations', {})
  end

  def decorations_draft
    draft['extra']['decorations'] if draft && draft['extra'] && draft['extra']['decorations']
  end

  # Returns whether this section has a specific decoration enabled
  def has_decoration? type, draft: false
    data = decorations_draft || decorations if draft
    data['enabled'].include?(type.to_s) if data.present?
  end

  # Returns the configuration for a specific decoration, if there is one.
  def decoration_options type, draft: false
    data = decorations_draft || decorations if draft
    defined?(data['options'][type.to_s]) ? (data['options'][type.to_s] || []) : []
  end

  # Returns the content for this section's sidetext (which is considered a kind of decoration)
  def decoration_sidetext draft: false
    data = decorations_draft || decorations if draft
    data['sidetext'] || ''
  end

  # Encode the list of countries that this section is visible for.
  def visibility_countries= list
    if list.is_a? Array
      super list.join(',')
    else
      super list
    end
  end

  # Decode the list of countries that this section is visible for.
  def visibility_countries
    list = super
    if list
      list.split(',')
    else
      []
    end
  end

  def published?
    page.published_at != nil
  end
end
