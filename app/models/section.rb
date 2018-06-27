class Section < ApplicationRecord
  extend CarrierwaveGlobalize

  # Extensions
  has_paper_trail
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

  # Associations
  belongs_to :page, polymorphic: true
  enum content_type: { text: 0, quote: 1, video: 2, image: 3, action: 5, special: 6 }
  enum visibility_type: { worldwide: 0, only_certain_countries: 1, except_certain_countries: 2 }

  TEXT_FORMATS = [:just_text, :with_quote, :with_image, :box_with_lefthand_image, :box_with_righthand_image, :box_over_image, :grid, :columns, :ancient_wisdom]
  IMAGE_FORMATS = [:fit_container_width, :fit_page_width]
  VIDEO_FORMATS = [:single, :gallery]
  ACTION_FORMATS = [:signup, :button]
  #enum format: TEXT_FORMATS + IMAGE_FORMATS + ACTION_FORMATS + SPECIAL_FORMATS

  def chapter_start?
    content_type == 'text' and title.present?
  end

  def chapter_slug
    title&.parameterize
  end

  def special?
    content_type == 'special'
  end

  def extra_attr key, default = nil
    if extra.present? and extra.is_a? Hash and extra.key? key
      extra[key]
    else
      default
    end
  end

  def image uuid = nil
    uuid = extra_attr('image_uuid') if uuid.nil?
    page.attachments.find_by(uuid: uuid)&.file
  end

  def video uuid = nil
    uuid = extra_attr('video_uuid') if uuid.nil?
    page.attachments.find_by(uuid: uuid)&.file
  end

  def decorations
    @decorations ||= extra_attr('decorations', {})
  end

  def has_decoration? type
    decorations['enabled'].include?(type.to_s) if decorations.present?
  end

  def decoration_options type
    defined?(decorations['options'][type.to_s]) ? (decorations['options'][type.to_s] || []) : []
  end

  def decoration_sidetext
    decorations['sidetext'] || ''
  end

  def visibility_countries= list
    if list.is_a? Array
      super list.join(',')
    else
      super list
    end
  end

  def visibility_countries
    list = super
    if list
      list.split(',')
    else
      []
    end
  end
end
