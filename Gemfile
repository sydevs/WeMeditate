source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Core gems
gem 'pg' # Use postgresql as the database for Active Record
gem 'puma' # Use Puma as the app server
gem 'rails', '~> 6.0.1'
gem 'sassc-rails' # Use SASS for stylesheets
gem 'slim-rails' # Use Slim for views
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets

gem 'webpacker' # Used to pack sass, js, and images
gem 'turbolinks' # Makes navigating your web application faster.

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
gem 'photoswipe-rails' # For image gallery
gem 'fomantic-ui-sass' # CSS framework for the admin/CMS pages

# Models
gem 'friendly_id' # Model routes use a slug instead of an ID number
gem 'array_enum' # Allows the use of enum arrays

# Uploads
gem 'carrierwave' # Core support for file uploads
gem 'carrierwave-google-storage' # Let's us store the files in Google Storage
gem 'google-api-client' # An unspecified dependency for carrierwave-google-storage
gem 'carrierwave-meta' # To get image meta data
gem 'google-cloud-storage' # Needed to access sitemaps
gem 'mini_magick' # Image processing during upload
gem 'streamio-ffmpeg' # To parse metadata from mp3 files

# Admin
gem 'audited', '4.9.0' # To track changes to the files (locked due to 5.x raising error on boot)
gem 'autosize' # To automatically grow text areas
gem 'diff-lcs' # For draft comparisons
gem 'kaminari' # For pagination
gem 'simple_form' # Takes care of grunt work when creating forms
gem 'sortable-rails' # Allows us to sort models with a drag and drop interface

# Globalize (translatable models)
# gem 'carrierwave_globalize' # for carrierwave support
gem 'friendly_id-globalize' # for friendly_id support
gem 'globalize' # Support for translating models

# Localization
gem 'carrierwave-i18n' # Localization of carrierwave
gem 'devise-i18n' # Localization for devise
gem 'i18n_data' # Adds some utility functions for localizing countries
gem 'kaminari-i18n' # Localization for kaminari
gem 'rails-i18n' # Localization of rails features
gem 'route_translator' # Adds support for translating URLs
gem 'country_to_locales_mapping' # Lookup the primary language for a given country

# Tools
gem 'rollbar' # Error tracking
gem 'seedbank' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.
gem 'sprig' # Used to populate the database with the pages and data used in the designs, for quick deployment and recovery.

# Misc
gem 'browser' # Detect the user's browser / device
gem 'httparty' # For http requests (specifically Klaviyo)
gem 'lograge' # Reduce verbosity of Rails logs
gem 'mail_form' # For the contact form
gem 'sitemap_generator' # For SEO purposes
gem 'geocoder' # For identifying users from specific regions
gem 'cloudflare-rails' # To restore client IP addresses after proxy
gem "recaptcha", require: "recaptcha/rails" # To protect against bots on the contact form

# Maybe needed later(?)
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password

group :staging, :development do
  # For profiling load times, exclude windows
  gem 'fast_stack'
  gem 'flamegraph'
  gem 'memory_profiler'
  gem 'rack-mini-profiler', require: false
  gem 'stackprof', platforms: %i[ruby]
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'rails_real_favicon' # For generating favicons
  gem 'selenium-webdriver'
  gem 'webdrivers' # used to install chromedriver on CI
end

group :development do
  gem 'better_errors' # More information about the error when you get a 500 (or other error) in the browser
  gem 'binding_of_caller' # Works with `better_errors` to let you query the code state in browser when an error occurs.
  gem 'i18n_generators'
  gem 'letter_opener' # Let's us capture test emails to verify that they were sent, and what markup was actually sent.
  gem 'listen' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen'
  gem 'switch_user', github: 'tslocke/switch_user' # Quickly switch between users without having to login/logout in development
  gem 'web-console'
end

group :test do
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
