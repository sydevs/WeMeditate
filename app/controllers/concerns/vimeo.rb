
## VIMEO
# This concern simplifies requests to the Vimeo API

module Vimeo

  FIELDS = %w[
    name width height
    pictures.sizes
    files.quality files.link files.type files.width files.height
    duration link
  ].join(',').freeze

  def self.retrieve_metadata vimeo_id
    Integer(vimeo_id) rescue raise ArgumentError, "Vimeo ID is not valid: \"#{vimeo_id}\""
    raise 'Vimeo Access Key has not been set' unless ENV['VIMEO_ACCESS_KEY'].present?

    uri = URI("https://api.vimeo.com/videos/#{vimeo_id}?fields=#{FIELDS}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{ENV['VIMEO_ACCESS_KEY']}"
  
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  
    if response.code == '404'
      puts "Vimeo API returned status code: #{response.code} for Vimeo ID: #{vimeo_id}"
      return nil
    elsif response.code != '200'
      raise "Vimeo API returned status code: #{response.code} for Vimeo ID: #{vimeo_id}"
    end

    response = JSON.parse(response.body)
    puts "Retrieved Vimeo Data for #{vimeo_id}\r\n#{response.pretty_inspect}"

    return {
      vimeo_id: vimeo_id,
      title: response['name'],
      width: response['width'],
      height: response['height'],
      thumbnail: response['pictures']['sizes'].last['link'],
      thumbnail_srcset: response['pictures']['sizes'].map { |pic| "#{pic['link']} #{pic['width']}w" }.join(','),
      sources: response['files']&.sort_by { |f| f['height'] || 10000 }.reverse,
      embed_url: "https://player.vimeo.com/video/#{vimeo_id}",
      duration: ActiveSupport::Duration.build(response['duration']).iso8601,
    }
  end

end
