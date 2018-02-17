class Section < ApplicationRecord
  extend CarrierwaveGlobalize

  # Extensions
  has_paper_trail
  translates :label, :title, :subtitle, :sidetext, :text, :quote, :credit, :action, :url, :image, :video

  attribute :label
  attribute :title
  attribute :subtitle
  attribute :sidetext
  attribute :text
  attribute :quote
  attribute :credit
  attribute :action
  attribute :url
  #attribute :image
  #attribute :video

  # Associations
  mount_translated_uploader :image, GenericImageUploader
  mount_translated_uploader :video, VideoUploader
  enum content_type: [:text, :quote, :video, :image, :banner, :action, :special]
  enum visibility_type: [:worldwide, :only_certain_countries, :except_certain_countries]

  TEXT_FORMATS = [:just_text, :with_quote, :adjacent_to_image, :within_image, :around_image, :with_image_background]
  IMAGE_FORMATS = [:fit_container_width, :fit_page_width]
  ACTION_FORMATS = [:signup, :button]
  #enum format: TEXT_FORMATS + IMAGE_FORMATS + ACTION_FORMATS + SPECIAL_FORMATS

  def chapter_start?
    content_type == 'text' and title.present?
  end

  def special?
    content_type == 'special'
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
