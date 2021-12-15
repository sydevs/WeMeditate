require_relative 'support'

puts ' -- Start Track Seeds -- '

# ===== CREATE ARTISTS ===== #
artists = {}

[{
  name: 'Leo Vertunni',
  url: 'http://indialucia.com',
}, {
  name: 'Sanjay Talwar',
  url: 'http://sahajayoga.org',
}, {
  name: 'Indialucia',
  url: 'http://indialucia.com',
}, {
  name: 'TEV Orchestra',
  url: 'http://www.theatreofeternalvalues.com',
}, {
  name: 'Shivakumar Sharma',
  url: 'http://www.santoor.com/',
}].each_with_index do |atts, index| # rubocop:disable Style/TrailingCommaInArrayLiteral
  atts[:image] = file_root.join("artists/#{index + 1}.jpg").open
  artists[index] = Artist.find_or_initialize_by(name: atts[:name])
  artists[index].update!(atts)
  puts "Created Artist - #{atts[:name]}"
end

# ===== CREATE INSTRUMENTS ===== #
instrument_filters = {}

%w[Sitar Vocal Flute].each_with_index do |name, index|
  key = name.underscore.to_sym
  instrument_filters[key] = InstrumentFilter.find_or_initialize_by(order: index)
  instrument_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("instrument_filters/#{name.dasherize.downcase}.svg").open,
    published: true,
    published_at: DateTime.now,
  })

  puts "Created Instrument Filter - #{name}"
end

# ===== CREATE MOODS ===== #
mood_filters = {}

%w[Calm Dynamic Joyful Innocent].each_with_index do |name, index|
  key = name.underscore.to_sym
  mood_filters[key] = MoodFilter.find_or_initialize_by(order: index)
  mood_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("mood_filters/#{name.dasherize.downcase}.svg").open,
    published: true,
    published_at: DateTime.now,
  })

  puts "Created Mood Filter - #{name}"
end

# ===== CREATE TRACKS ===== #
[{
  name: 'Raag Durga',
  artists: [artists[4], artists[0]],
  mood_filters: %i[dynamic joyful innocent],
  instrument_filters: %i[vocal flute],
}, {
  name: 'Morning Meditation',
  artists: [artists[0]],
  mood_filters: %i[dynamic calm],
  instrument_filters: %i[sitar],
}, {
  name: 'Raag Jayjayvanti',
  artists: [artists[1], artists[2], artists[0]],
  mood_filters: %i[dynamic innocent],
  instrument_filters: %i[vocal],
}, {
  name: 'Brahma Shodile',
  artists: [artists[2]],
  mood_filters: %i[joyful innocent],
  instrument_filters: %i[sitar flute],
}].each do |atts| # rubocop:disable Style/TrailingCommaInArrayLiteral
  atts.merge!({
    audio: file_root.join('general/music.mp3').open,
    mood_filters: atts[:mood_filters].map! { |k| mood_filters[k] },
    instrument_filters: atts[:instrument_filters].map! { |k| instrument_filters[k] },
    published: true,
    published_at: DateTime.now,
  })
  Track.find_or_initialize_by(name: atts[:name]).update!(atts)
  puts "Created Track - #{atts[:name]}"
end

puts ' -- Finished Track Seeds -- '
