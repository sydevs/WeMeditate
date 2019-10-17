module ApplicationHelper

  def admin?
    controller.class.name.split("::").first == 'Admin'
  end

  def image_url source
    path_to_url image_path(source)
  end

  def locale_host
    Rails.configuration.locale_hosts[I18n.locale]
  end
    
  def path_to_url path
    "https://#{locale_host}/#{path.sub(/^\//, '')}"
  end

  def amplitude_data tracks, playlists: true
    playlists = {}

    songs = tracks.each_with_index.map do |track, index|
      puts "PROCESS #{index} #{track.inspect}"
      if playlists
        track.instrument_filters.each do |filter|
          unless playlists.key?(filter.id)
            playlists[filter.id] = {
              title: filter.name,
              cover_art_url: filter.icon_url,
              songs: [],
            }
          end

          playlists[filter.id][:songs] << index
        end
      end

      {
        index: index,
        name: track.name,
        # artist: track.artists.first&.name,
        artists: amplitude_artists_data(track.artists),
        url: track.audio_url,
        cover_art_url: track.artists.sample&.image_url,
      }
    end

    if playlists
      playlists[0] = {
        title: '',
        songs: songs.first(10).map { |song| song[:index] },
      }
    end

    {
      songs: songs,
      playlists: playlists,
    }
  end

  def amplitude_artists_data artists
    artists.each.map do |artist|
=begin TODO: Reimplement responsive images
      jpg_srcset = []
      webp_srcset = []
      artist.image.versions.values.each do |version|
        jpg_srcset << "#{version.url} #{version.width}w"
        webp_srcset << "#{version.webp.url} #{version.width}w"
      end
=end

      {
        name: artist.name,
        url: artist.url,
        # image_srcset: {
        #   jpg: jpg_srcset.join(', '),
        #   webp: webp_srcset.join(', '),
        # },
      }
    end
  end

  def render_content record
    return content_for(:content) if content_for?(:content)
    return unless record.parsed_content.present?

    record.content_blocks.each do |block|
      concat render "content_blocks/#{block['type']}_block", block: block['data'].deep_symbolize_keys, record: record
    end

    return nil
  end

  def render_decoration type, block, **args
    return unless block[:decorations].present? && block[:decorations][type].present?

    data = block[:decorations][type]
    classes = [type]
    classes << "#{type}--#{args[:alignment] || data[:alignment] || 'left'}" unless type == :circle
    classes << "gradient--#{data[:color] || 'orange'}" if type == :gradient

    if type == :gradient && args[:size]
      for size in args[:size] do
        classes << "gradient--#{size}"
      end
    end

    if type == :circle
      inline_svg 'graphics/circle.svg', class: classes
    elsif type == :sidetext
      classes << 'sidetext--overlay' unless args[:static]
      content_tag :div, data[:text], class: classes
    else
      tag.div class: classes
    end
  end

  def simple_format_content text
    simple_format(text.gsub('<br>', "\n").html_safe).gsub("\n", '').html_safe
  end

  def vimeo_new_player? vimeo_data
    vimeo_data.is_a?(Hash) && vimeo_data[:sources].present?
  end

  def vimeo_tag vimeo_data, **args
    klass = args[:class].is_a?(Array) ? args[:class] : [args[:class]]
    klass << 'afterglow'
    klass << 'afterglow--ios' if browser.platform.ios?
    
    if vimeo_new_player?(vimeo_data)
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
      url = "https://player.vimeo.com/video/#{vimeo_data}"
      tag.iframe class: klass, data: { src: url }, width: '100%', height: '100%', frameborder: '0', allow: 'autoplay; fullscreen', webkitallowfullscreen: true, mozallowfullscreen: true, allowfullscreen: true
    end
  end
  
  def error message
    content_tag :div, class: 'alert' do
      tag.div "Error: #{message}. Only administrators can see this error", class: 'alert__message'
    end
  end

end
