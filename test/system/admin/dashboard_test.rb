require 'admin_system_test_case'

class Admin::DashboardTest < AdminSystemTestCase

  def setup
    login_as users(:super_admin)
  end

  test 'dashboard' do
    visit admin_url

    assert_selector 'h3', text: I18n.t('admin.dashboard.content.title')
  end

end
