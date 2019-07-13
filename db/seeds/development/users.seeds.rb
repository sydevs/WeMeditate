puts ' -- Start User Seeds -- '

User.roles.each do |role, _index|
  name = "Mr. #{role.titleize}"
  email = "#{role}@wemeditate.co"

  User.find_or_create_by(email: email).update!({
    name: name,
    email: email,
    role: role,
    password: 'password',
  })

  puts "Created User - #{name} <#{email}>"
end

puts ' -- Finished User Seeds -- '
