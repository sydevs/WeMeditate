require 'application_system_test_case'

class AdminSystemTestCase < ApplicationSystemTestCase

  def setup
    Capybara.app_host = "http://admin.#{ENV.fetch('LOCALHOST')}"
  end

end
