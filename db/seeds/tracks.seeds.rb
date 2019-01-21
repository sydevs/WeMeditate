
file_root = Rails.root.join('db/seeds/files')
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
}].each_with_index do |atts, index|
  atts[:image] = file_root.join("artists/#{index + 1}.jpg").open
  artists[index] = Artist.find_or_initialize_by(name: atts[:name])
  artists[index].update!(atts)
  puts "Created Artist - #{atts[:name]}"
end

# ===== CREATE INSTRUMENTS ===== #
instrument_filters = {}

['Voice', 'Sitar', 'Tabla', 'Flute'].each_with_index do |name, index|
  key = name.underscore.to_sym
  instrument_filters[key] = InstrumentFilter.find_or_initialize_by(order: index)
  instrument_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("instrument_filters/#{name.dasherize}.svg").open,
  })

  puts "Created Instrument Filter - #{name}"
end

# ===== CREATE MOODS ===== #
mood_filters = {}

['Calm', 'Dynamic', 'Joyful', 'Innocent'].each_with_index do |name, index|
  key = name.underscore.to_sym
  mood_filters[key] = MoodFilter.find_or_initialize_by(order: index)
  mood_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("mood_filters/#{name.dasherize}.svg").open,
  })

  puts "Created Mood Filter - #{name}"
end

# ===== CREATE TRACKS ===== #
[{
  name: 'Raag Darbari',
  artist: artists[0],
  mood_filters: [:dynamic, :joyful, :innocent],
  instrument_filters: [:voice, :flute],
}, {
  name: 'Raag Durga',
  artist: artists[0],
  mood_filters: [:dynamic, :calm],
  instrument_filters: [:tabla, :sitar],
}, {
  name: 'Raag Jayjayvanti',
  artist: artists[1],
  mood_filters: [:dynamic, :innocent],
  instrument_filters: [:voice],
}, {
  name: 'Brahma Shodile',
  artist: artists[2],
  mood_filters: [:joyful, :innocent],
  instrument_filters: [:tabla, :sitar, :flute],
}].each_with_index do |atts, index|
  atts[:audio] = file_root.join("general/music.mp3").open
  atts[:mood_filters].map! {|k| mood_filters[k]}
  atts[:instrument_filters].map! {|k| instrument_filters[k]}
  Track.find_or_initialize_by(name: atts[:name]).update!(atts)
  puts "Created Track - #{atts[:name]}"
end

puts ' -- Finished Track Seeds -- '
