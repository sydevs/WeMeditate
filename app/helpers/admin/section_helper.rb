module Admin::SectionHelper

  CONTENT_TYPE_TO_ICON_MAP = {
    text: 'font',
    quote: 'quote right',
    video: 'play',
    image: 'photo',
    banner: 'desktop',
    action: 'mouse pointer',
  }
      
  def content_type_icon ct
    content_tag :i, nil, class: "#{CONTENT_TYPE_TO_ICON_MAP[ct]} icon"
  end

end