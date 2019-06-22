module ApplicationHelper

  def playlist_data tracks
    tracks.each_with_index.map do |track, index|
      jpg_srcset = []
      webp_srcset = []
      track.artist.image.versions.values.each do |version|
        jpg_srcset << "#{version.url} #{version.width}w"
        webp_srcset << "#{version.webp.url} #{version.width}w"
      end

      {
        index: index,
        name: track.name,
        src: track.audio_url,
        mood_filters: track.mood_filters.map(&:id),
        instrument_filters: track.instrument_filters.map(&:id),
        artist: {
          name: track.artist.name,
          url: track.artist.url,
          image_srcset: {
            jpg: jpg_srcset.join(', '),
            webp: webp_srcset.join(', '),
          },
        },
      }
    end
  end

  def render_content record
    return unless record.content.present?

    cache record.content do
      JSON.parse(record.content)['blocks'].each do |block|
        concat render "content_blocks/#{block['type']}_block", block: block['data'].deep_symbolize_keys
      end
    end
  end

  def render_decoration type, block, **args
    return unless block[:decorations].present? and block[:decorations][type].present?

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
      content_tag :div, data, class: classes
    else
      tag.div class: classes
    end
  end

end
