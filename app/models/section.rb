## SECTION
# A section represents a block of text, an image, or some interactive element that should be rendered on the associated page.

# TYPE: SECTION
# The Section model is a unique kind of model that is used by all "Page"-type models to build their content.

class Section < ApplicationRecord
  extend CarrierwaveGlobalize

  # Extensions
  #has_paper_trail
  translates :label, :title, :subtitle, :text, :quote, :credit, :action, :url, :extra

  attribute :label
  attribute :title
  attribute :subtitle
  attribute :text
  attribute :quote
  attribute :credit
  attribute :action
  attribute :url
  attribute :extra
  alias name label

  # Associations
  belongs_to :page, polymorphic: true
  enum content_type: { text: 0, quote: 1, video: 2, image: 3, action: 5, special: 6 }
  enum visibility_type: { worldwide: 0, only_certain_countries: 1, except_certain_countries: 2 }

  # Validations
  validates :content_type, presence: true
  validates :format, presence: true, if: -> { content_type != 'quote' }

  # Scopes
  default_scope { order( :order ) }

  # Formats - A list of recognized non-special formats, which will be shown in the CMS
  TEXT_FORMATS = [:just_text, :with_quote, :with_image, :box_with_lefthand_image, :box_with_righthand_image, :box_over_image, :grid, :columns, :ancient_wisdom]
  IMAGE_FORMATS = [:fit_container_width, :fit_page_width, :gallery]
  VIDEO_FORMATS = [:single, :gallery]
  ACTION_FORMATS = [:signup, :button]

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
    elsif format.present?
      format_name || content_type_name
    end
  end

  def format_name
    format.present? ? I18n.translate("activerecord.attributes.section.formats.#{format}") : nil
  end

  def content_type_name
    content_type.present? ? I18n.translate("activerecord.attributes.section.content_types.#{content_type}") : nil
  end

  # Shorthand to access the main image associate with this section, if there is one.
  def image uuid = nil
    uuid = extra_attr('image_uuid') if uuid.nil?
    page.attachments.find_by(uuid: uuid)&.file
  end

  # Shorthand to access the main video associate with this section, if there is one.
  def video uuid = nil
    uuid = extra_attr('video_uuid') if uuid.nil?
    page.attachments.find_by(uuid: uuid)&.file
  end

  # Shorthand to access the decoration configuration for this section
  def decorations
    @decorations ||= extra_attr('decorations', {})
  end

  # Returns whether this section has a specific decoration enabled
  def has_decoration? type
    decorations['enabled'].include?(type.to_s) if decorations.present?
  end

  # Returns the configuration for a specific decoration, if there is one.
  def decoration_options type
    defined?(decorations['options'][type.to_s]) ? (decorations['options'][type.to_s] || []) : []
  end

  # Returns the content for this section's sidetext (which is considered a kind of decoration)
  def decoration_sidetext
    decorations['sidetext'] || ''
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
end
