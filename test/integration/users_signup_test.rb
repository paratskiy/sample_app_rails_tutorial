require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  setup do
    @invalid_user = { user: { name: '', email: 'user@invalid', password: 'foo',
                              password_confirmation: 'bar' } }
    @valid_user = { user: { name: 'Example User',
                            email: 'user@example.com',
                            password: 'password',
                            password_confirmation: 'password' } }
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: @invalid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: @valid_user
      follow_redirect!
    end
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
