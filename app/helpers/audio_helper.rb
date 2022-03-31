## AUDIO HELPER
# Helper methods for the audio player, which is implemented using the Howler library.

module AudioHelper

  def audio_from_tracks tracks
    tracks.map do |track|
      {
        title: track.name,
        file: track.audio_url,
        image: track.artists.first&.image&.url,
        duration: track.duration_as_string,
        filters: track.instrument_filters.pluck(:id),
        artists: track.artists.map { |a| [a.name, a.url] },
      }
    end
  end
  
  def audio_from_block block
    poster = MediaFile.find_by(id: block[:poster][:id])&.file

    block[:items].map do |item|
      audio = MediaFile.find_by(id: item[:audio][:id])
      {
        title: item[:title],
        file: audio.file.url,
        image: poster&.url, # TODO: Implement responsive images
        duration: duration_as_string(audio.meta['duration']),
      }
    end
  end

  # A string representation of the duration of this track
  def duration_as_string duration
    return '0:00' if duration.nil?

    Time.at(duration).utc.strftime('%-M:%S')
  end

end