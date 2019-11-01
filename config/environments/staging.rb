# Just use the production settings
require File.expand_path('production.rb', __dir__)

Rails.application.configure do
  # Here override any defaults
  config.force_ssl = false
  config.consider_all_requests_local = true
end
