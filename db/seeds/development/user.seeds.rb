
puts ' -- Start User Seeds -- '

User.find_or_create_by(email: 'super@test.com').update!({
  role: :super_admin,
  password: 'password',
})

puts "Created User - super@test.com"
puts ' -- Finished User Seeds -- '
