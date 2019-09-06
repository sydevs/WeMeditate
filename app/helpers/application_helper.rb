module ApplicationHelper

  def locale_host
    Rails.configuration.locale_hosts[I18n.locale]
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

      puts "SET #{index}"
      {
        index: index,
        name: track.name,
        artist: track.artists.first&.name,
        url: track.audio_url,
        cover_art_url: track.artists.first&.image_url,
      }
    end

    puts "SONGS #{songs}"

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

  def playlist_artist_data artists
    artists.each.map do |artist|
      jpg_srcset = []
      webp_srcset = []
      artist.image.versions.values.each do |version|
        jpg_srcset << "#{version.url} #{version.width}w"
        webp_srcset << "#{version.webp.url} #{version.width}w"
      end

      {
        name: artist.name,
        url: artist.url,
        image_srcset: {
          jpg: jpg_srcset.join(', '),
          webp: webp_srcset.join(', '),
        },
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

  def vimeo_tag vimeo_id, **args
    klass = args[:class].is_a?(Array) ? args[:class] : [args[:class]]
    inline = args[:inline] || false
    url = "https://player.vimeo.com/video/#{vimeo_id}?byline=false&title=false&author=false&portrait=false&playsinline=#{inline}"
    tag.iframe class: klass, data: { src: url }, frameborder: '0', width: '100%', height: '100%', allow: 'autoplay; fullscreen'
  end

end
