# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

PaperTrail.whodunnit = User.first.id unless User.first.nil?
Globalize.locale = :en
path = Rails.root.join('db', 'seeds', "#{Rails.env}.rb")
load path if File.exist?(path)
