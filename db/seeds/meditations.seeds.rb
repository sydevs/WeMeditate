require_relative 'support'

puts ' -- Start Meditation Seeds -- '

# ===== CREATE GOALS ===== #
goal_filters = {}

[
  'Calm', 'Self-confident', 'Satisfied', 'Creative', 'Focused', 'Joyful', 'Love',
  'Self-esteem', 'Humble', 'Silence', 'Harmony', 'Balanced', 'Dynamic', 'Happy',
].each_with_index do |name, index|
  key = name.underscore.to_sym
  goal_filters[key] = GoalFilter.find_or_initialize_by(order: index)
  goal_filters[key].update!({
    name: name,
    order: index,
    icon: file_root.join("goal_filters/#{name.dasherize.downcase}.svg").open,
  })

  puts "Created Goal Filter - #{name}"
end

# ===== CREATE DURATIONS ===== #
duration_filters = {}

[20, 10, 5].each do |minutes|
  duration_filters[minutes] = DurationFilter.find_or_initialize_by(minutes: minutes)
  duration_filters[minutes].update!(minutes: minutes)
  puts "Created Duration Filter - #{minutes}"
end

# ===== CREATE TRACKS ===== #
[{
  name: 'First Meditation Experience',
  goal_filters: %i[harmony self_confident],
  duration_filter: 10,
}, {
  name: 'Silent Meditation',
  goal_filters: %i[silence calm],
  duration_filter: 5,
}, {
  name: 'Long Meditation',
  goal_filters: %i[love],
  duration_filter: 20,
}, {
  name: 'Four Petals',
  goal_filters: %i[balanced],
  duration_filter: 10,
}, {
  name: 'Balancing',
  goal_filters: %i[balanced],
  duration_filter: 5,
}].each_with_index do |atts, index| # rubocop:disable Style/TrailingCommaInArrayLiteral
  atts[:image] = file_root.join("meditations/background-#{(index % 2) + 1}.jpg").open
  atts[:video] = file_root.join('general/video.mp4').open
  atts[:goal_filters].map! { |k| goal_filters[k] }
  atts[:duration_filter] = duration_filters[atts[:duration_filter]]
  atts[:excerpt] = 'Feel like you’re in need of a pick me up? Banish those negative thoughts which are putting you down and boost your confidence.'
  Meditation.find_or_initialize_by(name: atts[:name]).update!(atts)
  puts "Created Meditation - #{atts[:name]}"
end

puts ' -- Finished Meditation Seeds -- '
