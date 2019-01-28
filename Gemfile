source 'https://rubygems.org'
ruby '2.4.3'

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
#gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# Users
gem 'devise' # Adds all the core features for users - user sessions, login, password recovery, etc
gem 'devise_invitable' # Adds support to invite users by email
gem 'regulator' # Adds permissions, so we can control users' access to certain pages

# Front End
gem 'normalize-rails' # To normalize CSS
gem 'autoprefixer-rails' # For automatic cross browser CSS compatibility
gem 'semantic-ui-sass' # CSS framework for the admin/CMS pages
gem 'jquery-rails' # Add jQuery
gem 'google-tag-manager-rails'
gem 'jquery-slick-rails' # A slider library
gem 'inline_svg' # To embed svg files

# Models
gem 'friendly_id' # Model routes use a slug instead of an ID number
gem 'geocoder' # Integrates with Google Maps or other providers to geocode addresses
gem 'jsonb_accessor' # Makes it simpler to access attributes of a jsonb database column

# Uploads
gem 'carrierwave' # Core support for file uploads
gem 'carrierwave-google-storage' # Let's us store the files in Google Storage
gem 'mini_magick' # Image processing during upload
gem 'rack-raw-upload'

# Admin
gem 'simple_form' # Takes care of grunt work when creating forms
gem 'autosize' # To automatically grow text areas
gem 'quilljs-rails' # A wysiwyg text editor
gem 'sortable-rails' # Allows us to sort models with a drag and drop interface
gem 'kaminari' # For pagination

# Globalize (translatable models)
gem 'globalize' # Support for translating models
gem 'carrierwave_globalize' # for carrierwave support (referencing my own repo to add multi-uploader support)
#gem 'carrierwave_globalize', path: '~/Documents/Projects/Other/carrierwave_globalize' # for multiple uploaders support
gem 'friendly_id-globalize' # for friendly_id support

# Localization
gem 'rails-i18n' # Localization of rails features
gem 'carrierwave-i18n' # Localization of carrierwave
gem 'devise-i18n' # Localization for devise
gem 'route_translator' # Adds support for translating URLs
gem 'i18n_data' # Adds some utility functions for localizing countries

# Tools
gem 'sprig' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.
gem 'seedbank' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.

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
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors' # More information about the error when you get a 500 (or other error) in the browser
  gem 'binding_of_caller' # Works with `better_errors` to let you query the code state in browser when an error occurs.
  gem 'switch_user', github: 'tslocke/switch_user' # Quickly switch between users without having to login/logout in development
  gem 'i18n_generators'
  gem 'letter_opener' # Let's us capture test emails to verify that they were sent, and what markup was actually sent.
  gem 'dotenv' # Should load .env file automatically, but doesn't seem to be working.
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
