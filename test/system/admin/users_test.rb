require 'admin_system_test_case'

class Admin::UsersTest < AdminSystemTestCase

  def setup
    login_as users(:super_admin)
  end

  test 'listing users' do
    visit admin_url('users')

    assert_selector 'h1', text: /#{User.model_name.human(count: User.count)}/i
  end

  test 'inviting a user' do
    email = 'gordon.freeman@example.com'

    visit admin_url('users/new')

    fill_in 'user_name', with: 'Gordon Freeman'
    fill_in 'user_email', with: email
    click_on 'Invite'

    # this will create the user, send the invitation and redirect to the users list

    assert_selector 'div', text: email
    assert_selector 'div', text: I18n.t('admin.index.status.pending')
  end

end
