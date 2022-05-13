puts ' -- Start User Seeds -- '

User.roles.each do |role, _index|
  name = "Mr. #{role.titleize}"
  email = "#{role}@wemeditate.com"

  User.find_or_create_by(email: email).update!({
    name: name,
    email: email,
    role: role,
    password: 'password',
    languages_known: I18n.available_locales,
    invitation_created_at: DateTime.now,
    invitation_sent_at: DateTime.now,
    invitation_accepted_at: DateTime.now,
  })

  puts "Created User - #{name} <#{email}>"
end

puts ' -- Finished User Seeds -- '
