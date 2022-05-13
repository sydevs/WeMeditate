# Just use the production settings
require File.expand_path('production.rb', __dir__)

Rails.application.configure do
  # Here override any defaults
  config.force_ssl = false
  config.consider_all_requests_local = true

  # To allow HTTPS on CloudFlare but HTTP on Heroku
  config.action_controller.forgery_protection_origin_check = false

  # Override mailer host
  config.action_mailer.default_url_options = { host: 'admin-staging.wemeditate.com' }
end
