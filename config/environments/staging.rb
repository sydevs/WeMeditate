# Just use the production settings
require File.expand_path('../production.rb', __FILE__)
 
Rails.application.configure do
  # Here override any defaults
  config.force_ssl = false
end