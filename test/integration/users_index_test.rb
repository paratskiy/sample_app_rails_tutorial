require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:paratskiy)
    @non_admin = users(:archer)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'index as not-logged-in' do
    get users_path
    assert_redirected_to login_path
    follow_redirect!
    assert_select 'div.alert-danger'
  end

  test 'index should not show non activated users' do
    log_in_as(@admin)
    user = users(:lana)
    user.toggle!(:activated)
    get users_path
    assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
  end
end
