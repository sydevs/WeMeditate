require_relative 'boot'

require 'rails/all'
require 'i18n/backend/fallbacks'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wemeditate
  class Application < Rails::Application
    config.time_zone = 'London'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.twitter_handle = '@wemeditate'
    config.exceptions_app = self.routes
    config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
  end
end
