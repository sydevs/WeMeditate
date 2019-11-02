require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  driven_by :selenium, using: :headless_chrome

  include Warden::Test::Helpers

  def admin_url path = '', locale: 'en'
    "http://admin.#{ENV.fetch('LOCALHOST')}/#{locale}/#{path}"
  end

end
