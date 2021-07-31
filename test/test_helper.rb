require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

# Open up localhost connections for system tests to work out
WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

end
