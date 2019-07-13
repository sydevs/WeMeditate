puts ' -- Start User Seeds -- '

User.roles.each do |role, _index|
  email = "#{role}@wemeditate.co"

  User.find_or_create_by(email: email).update!({
    email: email,
    role: role,
    password: 'password',
  })

  puts "Created User - #{email}"
end

puts ' -- Finished User Seeds -- '
