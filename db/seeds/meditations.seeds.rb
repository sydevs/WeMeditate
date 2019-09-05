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
    published: true,
    published_at: DateTime.now,
  })

  puts "Created Goal Filter - #{name}"
end

# ===== CREATE DURATIONS ===== #
duration_filters = {}

[20, 10, 5].each do |minutes|
  duration_filters[minutes] = DurationFilter.find_or_initialize_by(minutes: minutes)
  duration_filters[minutes].update!({
    minutes: minutes,
    published: true,
    published_at: DateTime.now,
  })
  puts "Created Duration Filter - #{minutes}"
end

# ===== CREATE MEDITATIONS ===== #
[{
  name: 'First Meditation Experience',
  slug: I18n.translate('routes.self_realization'),
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
  atts.merge!({
    image: file_root.join("meditations/background-#{(index % 2) + 1}.jpg").open,
    vertical_vimeo_id: 152153054,
    horizontal_vimeo_id: 208643382,
    goal_filters: atts[:goal_filters].map! { |k| goal_filters[k] },
    duration_filter: duration_filters[atts[:duration_filter]],
    excerpt: 'Feel like you’re in need of a pick me up? Banish those negative thoughts which are putting you down and boost your confidence.',
    published: true,
    published_at: DateTime.now,
  })

  Meditation.find_or_initialize_by(name: atts[:name]).update!(atts)
  puts "Created Meditation - #{atts[:name]}"
end

# ===== GENERIC MEDITATIONS ===== #
20.times.each do |index|
  index += 1
  meditation = Meditation.find_or_initialize_by(name: "Meditation #{index}")
  meditation.update!({
    image: file_root.join("meditations/background-#{(index % 2) + 1}.jpg").open,
    vertical_vimeo_id: 152153054,
    horizontal_vimeo_id: 208643382,
    goal_filters: goal_filters.values.sample([1, 2].sample),
    duration_filter: duration_filters.values.sample,
    excerpt: 'Feel like you’re in need of a pick me up? Banish those negative thoughts which are putting you down and boost your confidence.',
    published: true,
    published_at: DateTime.now,
  })

  puts "Created Generic Meditation #{index}"
end

puts ' -- Finished Meditation Seeds -- '
