require 'net/http'
require 'net/https'
require 'uri'

def file_root
  Rails.root.join('db/seeds/files')
end

def attachment path, parent
  media_file = parent.media_files.create!(file: Rails.root.join('db/seeds/files').join(path).open)
  media_file.id
end

def sentences count
  [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Aliquam gravida neque quam, eget eleifend dolor ultricies eget.',
    'Morbi sed imperdiet dolor. Nulla facilisi. Nulla sed erat cursus, bibendum tortor non, suscipit ante.',
    'Praesent venenatis libero ante, in vestibulum eros aliquam eu. Vivamus non efficitur turpis.',
    'Integer vitae nunc id ligula luctus mollis ut sit amet velit. Praesent congue sed mauris vitae aliquam.',
    'Phasellus tempor sem ut libero consectetur feugiat.',
    'Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper.',
    'Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat.',
    'Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros.',
    'Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.',
    'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi.',
    'Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus.',
    'Praesent sit amet est et nisl mattis facilisis.',
    'Cras sed mauris sed arcu fermentum interdum vel imperdiet enim.',
    'Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
    'Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus.',
    'In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo.',
    'Mauris fringilla orci est, non facilisis urna euismod at.',
    'Cras lobortis tellus purus, id cursus purus rhoncus at.',
    'Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis.',
    'Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi.',
    'Vivamus enim erat, sagittis a bibendum nec, varius non nulla.',
    'Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus.',
    'Phasellus malesuada mattis risus sit amet eleifend.',
  ].shuffle.sample(count).join(' ')
end

def paragraphs count
  [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam gravida neque quam, eget eleifend dolor ultricies eget. Morbi sed imperdiet dolor. Nulla facilisi. Nulla sed erat cursus, bibendum tortor non, suscipit ante. Praesent venenatis libero ante, in vestibulum eros aliquam eu. Vivamus non efficitur turpis. Integer vitae nunc id ligula luctus mollis ut sit amet velit. Praesent congue sed mauris vitae aliquam.',
    'Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.',
    'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
    'Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus. In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo. Mauris fringilla orci est, non facilisis urna euismod at. Cras lobortis tellus purus, id cursus purus rhoncus at. Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis. Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi. Vivamus enim erat, sagittis a bibendum nec, varius non nulla. Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus. Phasellus malesuada mattis risus sit amet eleifend.',
  ].shuffle.sample(count).map{|p| "<p>#{p}</p>"}.join
end

def vimeo_attachment vimeo_id = nil
  vimeo_id ||= [343376322, 238447552, 298038460, 249414159, 178920145].sample
  puts "Loading Vimeo ##{vimeo_id}"
  uri = URI("https://api.vimeo.com/videos/#{vimeo_id}?fields=name,pictures.sizes")
  request = Net::HTTP::Get.new(uri)
  request['Authorization'] = "Bearer #{ENV['VIMEO_ACCESS_KEY']}"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  response = JSON.parse(response.body)

  return {
    vimeo_id: vimeo_id,
    title: response['name'],
    thumbnail: response['pictures']['sizes'].last['link'],
    thumbnail_srcset: response['pictures']['sizes'].map { |pic| "#{pic['link']} #{pic['width']}w" }.join(','),
  }
end

def content_attachment path, parent
  puts "Uploading #{path}"
  # media_file = parent.media_files.find_or_initialize_by(name: name)
  # media_file.update!({ name: name, category: type, file: Rails.root.join('db/seeds/files').join(path).open })
  media_file = parent.media_files.create!({ file: Rails.root.join('db/seeds/files').join(path).open })
  { id: media_file.id, preview: media_file.file.small.url }
end

def content blocks
  puts "Preparing #{blocks.length} content blocks"
  {
    time: Time.now.to_i,
    blocks: blocks,
    version: '2.12.4', # EditorJS at the last time when the structure of seed JSONs were checked.
  }.to_json
end

def decoration format, alignment: :left, size: :medium, text: :text, color: :orange
  block = {
    type: :decoration,
    data: {
      format: format,
      alignment: alignment,
    },
  }

  block[:data][:text] = text if format == :sidetext
  block[:data][:size] = size unless format == :sidetext
  block[:data][:color] = color if format == :gradient
  block
end
