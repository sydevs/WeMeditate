## VIDEO HELPER
# Helps wth the rendering of videos

module VideoHelper

  # Check if a set of vimeo metadata has the necessary attributes for the afterglow video player.
  def supports_afterglow_player? vimeo_data
    # We need to have download links stored in `sources` in order to use the afterglow player.
    vimeo_data.is_a?(Hash) && vimeo_data[:sources].present?
  end

  # Render a video player for a set of vimeo metadata
  def vimeo_tag vimeo_data, **args
    if supports_afterglow_player?(vimeo_data)
      klass = args[:class].is_a?(Array) ? args[:class] : [args[:class]]
      klass << 'afterglow'
      klass << 'afterglow--ios' if browser.platform.ios?

      skin = args[:skin] == :light ? 'light' : 'dark'
      source = tag.source type: 'video/mp4', src: vimeo_data[:download_url]
      content_tag :video, {
        class: klass,
        width: vimeo_data[:width],
        height: vimeo_data[:height],
        poster: vimeo_data[:thumbnail],
        data: { skin: skin }
      } do
        vimeo_data[:sources].each do |source|
          next if source[:quality] == 'hls'

          concat tag.source({
            type: source[:type], 
            src: source[:link], 
            data: { quality: ('hd' if source[:quality] != 'sd') }
          })
        end
      end
    else
      # Fallback to a simple vimeo iframe, if the afterglow player is not supported.
      url = "https://player.vimeo.com/video/#{vimeo_data}"
      tag.iframe class: klass, data: { src: url }, width: '100%', height: '100%', frameborder: '0', allow: 'autoplay; fullscreen', webkitallowfullscreen: true, mozallowfullscreen: true, allowfullscreen: true
    end
  end
  
end
