class Section < ApplicationRecord

  # Extensions
  has_paper_trail
  jsonb_accessor :parameters,
    title: :string,
    subtitle: :string,
    text: :text,
    quote: :text,
    credit: :string,
    credit_subtitle: :string,
    action_text: :string,
    action_url: :string,
    video_url: :string,
    format: :string

  # Associations
  mount_uploaders :images, GenericImageUploader
  enum content_type: [:text, :quote, :video, :image, :banner, :action]
  enum visibility_type: [:worldwide, :only_certain_countries, :except_certain_countries]
  enum language: I18n.available_locales

  TEXT_FORMATS = [:just_text, :with_quote, :adjacent_to_image, :within_image, :around_image, :with_image_background]
  IMAGE_FORMATS = [:fit_container_width, :fit_page_width]
  ACTION_FORMATS = [:signup, :button]
  #enum format: TEXT_FORMATS + IMAGE_FORMATS + ACTION_FORMATS

  # Validations
  before_create :set_language

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

  protected
    def set_language
      self.language = I18n.locale
    end
end
