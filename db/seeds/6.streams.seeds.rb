require_relative 'support'

puts ' -- Start Stream Seeds -- '

# ===== CREATE STREAMS ===== #
streams = {}

[{
  name: 'Live Meditation',
  slug: 'main',
  excerpt: sentences(4),
  stream_url: 'www.google.com',
  locale: :en,
  location: 'London',
  start_date: 1.week.ago.monday,
  start_time: '17:00',
  end_time: '18:00',
  recurrence: %i[monday],
  state: :published,
  time_zone_identifier: 'Europe/London',
  time_zone_offset: 0,
  target_time_zones: [0],
}].each_with_index do |attributes, index|
  stream = Stream.find_or_initialize_by(name: attributes[:name])
  stream.assign_attributes(attributes)
  stream.save! # NOTE: record must be saved to assign thumbnail attachment
  stream.update!(thumbnail_id: attachment('classes/streams.jpg', stream))
  streams[index] = stream
  puts "Created Stream - #{attributes[:name]}"
end

puts ' -- Finished Stream Seeds -- '
