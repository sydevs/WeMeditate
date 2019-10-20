module AudioHelper

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
        duration: track.duration_as_string,
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

end
