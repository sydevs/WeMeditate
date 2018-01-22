class Section < ApplicationRecord
  has_paper_trail
  
  belongs_to :article

  store_accessor :parameters, :text, :youtube_id, :image

  enum content_type: [:text, :video, :text_with_image]
  enum visibility_type: [:worldwide, :only_certain_countries, :except_certain_countries]
  enum language: I18n.available_locales

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
