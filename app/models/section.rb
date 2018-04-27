class Section < ApplicationRecord
  extend CarrierwaveGlobalize

  # Extensions
  has_paper_trail
  translates :label, :title, :subtitle, :sidetext, :text, :quote, :credit, :action, :url, :images, :videos

  attribute :label
  attribute :title
  attribute :subtitle
  attribute :sidetext
  attribute :text
  attribute :quote
  attribute :credit
  attribute :action
  attribute :url
  attribute :images
  attribute :videos

  # Associations
  belongs_to :page, polymorphic: true
  mount_translated_uploaders :images, GenericImageUploader
  mount_translated_uploaders :videos, VideoUploader
  enum content_type: { text: 0, quote: 1, video: 2, image: 3, action: 5, special: 6 }
  enum visibility_type: { worldwide: 0, only_certain_countries: 1, except_certain_countries: 2 }

  TEXT_FORMATS = [:just_text, :with_quote, :with_image, :box_with_lefthand_image, :box_with_righthand_image, :box_over_image, :grid, :ancient_wisdom]
  IMAGE_FORMATS = [:fit_container_width, :fit_page_width]
  ACTION_FORMATS = [:signup, :button]
  #enum format: TEXT_FORMATS + IMAGE_FORMATS + ACTION_FORMATS + SPECIAL_FORMATS

  def chapter_start?
    content_type == 'text' and title.present?
  end

  def special?
    content_type == 'special'
  end

  def image
    images[0]
  end

  def video
    videos[0]
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
