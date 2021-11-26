require_relative 'support'

puts ' -- Start Stream Seeds -- '

# ===== CREATE STREAMS ===== #
streams = {}

[{
  name: 'Live Meditation',
  slug: 'main',
  excerpt: sentences(4),
  stream_url: 'www.google.com',
  location: 'London',
  start_date: 1.week.ago.monday,
  start_time: '17:00',
  end_time: '18:00',
  recurrence: %i[monday],
  time_zone_identifier: 'Europe/London',
  time_zone_offset: 0,
  target_time_zones: [0],
}].each_with_index do |atts, index| # rubocop:disable Style/TrailingCommaInArrayLiteral
  stream = Stream.find_or_initialize_by(name: atts[:name])
  atts.merge!({
    state: :published,
    locale: :en,
    thumbnail_id: attachment("classes/streams.jpg", stream),
  })
  stream.update!(atts)
  streams[index] = stream
  puts "Created Stream - #{atts[:name]}"
end

puts ' -- Finished Stream Seeds -- '
