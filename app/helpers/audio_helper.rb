## AUDIO HELPER
# Helper methods for the audio player, which is implemented using the Amplitude library.

module AudioHelper

  # Get the data which is relevant to make the amplitude player work
  def amplitude_block_data block
    songs = block[:items].each_with_index.map do |item, index|
      poster = MediaFile.find_by(id: block[:poster][:id])&.file
      audio = MediaFile.find_by(id: item[:audio][:id])

      {
        index: index,
        name: item[:title],
        url: audio.file.url,
        cover_art_url: poster&.url, # TODO: Implement responsive images
        image: poster&.to_json,
        duration: duration_as_string(audio.meta[:duration]),
      }
    end

    {
      songs: songs,
      playlists: [{
        title: '',
        songs: songs.map { |song| song[:index] },
      }],
    }
  end

  # Get the data which is relevant to make the amplitude player work
  def amplitude_track_data tracks, playlists: false
    playlists_data = {}

    songs = tracks.each_with_index.map do |track, index|
      if playlists
        # Playlists are determined by instrument filters
        track.instrument_filters.each do |filter|
          # Create a new playlist if it doesn't already exist
          unless playlists_data.key?(filter.id)
            playlists_data[filter.id] = {
              title: filter.name,
              cover_art_url: filter.icon_url,
              songs: [],
            }
          end

          # Add this song to the playlist.
          playlists_data[filter.id][:songs] << index
        end
      end

      image = track.artists.first&.image

      # Return the data for this song to be added to the songs list
      {
        index: index,
        name: track.name,
        artists: amplitude_artists_data(track.artists),
        url: track.audio_url,
        cover_art_url: image&.url,
        image: image&.to_json,
        duration: track.duration_as_string,
      }
    end

    # If any playlists are defined, then set the first playlist to be a list of the first 10 songs
    if playlists
      playlists_data[0] = {
        title: '',
        songs: songs.first(10).map { |song| song[:index] },
      }
    end

    {
      songs: songs,
      playlists: playlists_data,
    }
  end

  # Get the relevant data for a set of artists
  def amplitude_artists_data artists
    artists.each.map do |artist|
=begin TODO: Reimplement responsive images for amplitude
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

  # A string representation of the duration of this track
  def duration_as_string duration
    return '0:00' if duration.nil?

    Time.at(duration).utc.strftime('%M:%S')
  end

end
