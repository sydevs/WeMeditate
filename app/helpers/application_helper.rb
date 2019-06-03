module ApplicationHelper

  def playlist_data tracks
    tracks.each_with_index.map do |track, index|
      {
        index: index,
        name: track.name,
        src: track.audio_url,
        mood_filters: track.mood_filters.map(&:id),
        instrument_filters: track.instrument_filters.map(&:id),
        artist: {
          name: track.artist.name,
          url: track.artist.url,
          image: track.artist.image_url,
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
    classes << "#{type}--#{args[:alignment] || data[:alignment] || 'left'}"
    classes << "gradient--#{data[:color] || 'orange'}" if type == :gradient
    classes << "gradient--#{args[:size] || data[:size] || 'medium'}" if type == :gradient

    if type == :sidetext
      classes << 'sidetext--overlay' unless args[:static]
      content_tag :div, data, class: classes
    else
      tag.div class: classes
    end
  end

end
