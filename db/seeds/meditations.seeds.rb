
file_root = Rails.root.join('db/seeds/files')
puts ' -- Start Meditation Seeds -- '

# ===== CREATE GOALS ===== #
goal_filters = {}

[
  'Calm', 'Self-confident', 'Satisfied', 'Creative', 'Focused', 'Joyful', 'Love',
  'Self-esteem', 'Humble', 'Silence', 'Harmony', 'Balanced', 'Dynamic', 'Happy'
].each_with_index do |name, index|
  key = name.underscore.to_sym
  goal_filters[key] = GoalFilter.find_or_initialize_by(order: index)
  goal_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("goal_filters/#{name.dasherize}.svg").open,
  })

  puts "Created Goal Filter - #{name}"
end

# ===== CREATE DURATIONS ===== #
duration_filters = {}

[10, 5, 2].each_with_index do |minutes, index|
  duration_filters[minutes] = DurationFilter.find_or_initialize_by(minutes: minutes)
  duration_filters[minutes].update!({minutes: minutes})
  puts "Created Duration Filter - #{minutes}"
end

# ===== CREATE TRACKS ===== #
[{
  name: 'First Meditation Experience',
  goal_filters: [:harmony, :self_confident],
  duration_filter: 5,
}, {
  name: 'Silent Meditation',
  goal_filters: [:silence, :calm],
  duration_filter: 2,
}, {
  name: 'Long Meditation',
  goal_filters: [:love],
  duration_filter: 10,
}, {
  name: 'Four Petals',
  goal_filters: [:balanced],
  duration_filter: 5,
}, {
  name: 'Balancing',
  goal_filters: [:balanced],
  duration_filter: 2,
}].each_with_index do |atts, index|
  atts[:image] = file_root.join("meditations/background-#{(index % 2) + 1}.jpg").open
  atts[:video] = file_root.join('general/video.mp4').open
  atts[:goal_filters].map! {|k| goal_filters[k]}
  atts[:duration_filter] = duration_filters[atts[:duration_filter]]
  atts[:excerpt] = 'Sahaja Yoga is a method of obtaining a real experience of introspection and worldview.'
  Meditation.find_or_initialize_by(name: atts[:name]).update!(atts)
  puts "Created Meditation - #{atts[:name]}"
end

puts ' -- Finished Meditation Seeds -- '
