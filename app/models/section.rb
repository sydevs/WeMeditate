class Section < ApplicationRecord

  # Extensions
  has_paper_trail
  store_accessor :parameters, :text, :youtube_id, :image

  # Associations
  belongs_to :article
  enum content_type: [:text, :video, :text_with_image]
  enum visibility_type: [:worldwide, :only_certain_countries, :except_certain_countries]
  enum language: I18n.available_locales

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
