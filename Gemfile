source 'https://rubygems.org'
ruby '2.5.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core gems
gem 'rails', '~> 5.2.2'
gem 'pg', '~> 0.18' # Use postgresql as the database for Active Record
gem 'puma', '~> 3.7' # Use Puma as the app server
gem 'sassc-rails' # Use SASS for stylesheets
gem 'slim-rails' # Use Slim for views
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

gem 'rails_serve_static_assets' # Allow the heroku app to serve static files
gem 'turbolinks', '~> 5' # Makes navigating your web application faster.
# gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Users
gem 'devise' # Adds all the core features for users - user sessions, login, password recovery, etc
gem 'devise_invitable' # Adds support to invite users by email
gem 'regulator' # Adds permissions, so we can control users' access to certain pages

# Front End
gem 'autoprefixer-rails' # For automatic cross browser CSS compatibility
gem 'google-tag-manager-rails'
gem 'inline_svg' # To embed svg files
gem 'jquery-rails' # Add jQuery
gem 'jquery-slick-rails' # A slider library
gem 'normalize-rails' # To normalize CSS
gem 'semantic-ui-sass' # CSS framework for the admin/CMS pages

# Models
gem 'friendly_id' # Model routes use a slug instead of an ID number
gem 'jsonb_accessor' # Makes it simpler to access attributes of a jsonb database column

# Uploads
gem 'carrierwave' # Core support for file uploads
gem 'carrierwave-google-storage' # Let's us store the files in Google Storage
gem 'mini_magick' # Image processing during upload
gem 'rack-raw-upload'

# Admin
gem 'autosize' # To automatically grow text areas
gem 'kaminari' # For pagination
gem 'simple_form' # Takes care of grunt work when creating forms
gem 'sortable-rails' # Allows us to sort models with a drag and drop interface

# Globalize (translatable models)
gem 'carrierwave_globalize' # for carrierwave support
gem 'globalize' # Support for translating models
gem 'friendly_id-globalize' # for friendly_id support

# Localization
gem 'carrierwave-i18n' # Localization of carrierwave
gem 'i18n_data' # Adds some utility functions for localizing countries
gem 'rails-i18n' # Localization of rails features
gem 'devise-i18n' # Localization for devise
gem 'route_translator', '~> 6.0.0' # Adds support for translating URLs
gem 'kaminari-i18n' # Localization for kaminari

# Tools
gem 'seedbank' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.
gem 'sprig' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.

# Misc
gem 'gibbon' # For MailChimp Integration
gem 'mail_form' # For the contact form
gem 'sidekiq' # To power active jobs
gem 'sitemap_generator' # For SEO purposes

# Maybe needed later(?)
# gem 'therubyracer', platforms: :ruby # See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views
# gem 'redis', '~> 3.0' # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
# gem 'capistrano-rails', group: :development # Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors' # More information about the error when you get a 500 (or other error) in the browser
  gem 'binding_of_caller' # Works with `better_errors` to let you query the code state in browser when an error occurs.
  gem 'dotenv' # Should load .env file automatically, but doesn't seem to be working.
  gem 'i18n_generators'
  gem 'letter_opener' # Let's us capture test emails to verify that they were sent, and what markup was actually sent.
  gem 'listen', '>= 3.0.5', '< 3.2' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'switch_user', github: 'tslocke/switch_user' # Quickly switch between users without having to login/logout in development
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
