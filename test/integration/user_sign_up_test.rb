require 'test_helper'

class UserSignUpTest < ActionDispatch::IntegrationTest

  test "user signing up" do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, user: { email: 'user@example.com',
                                           password:              'password',
                                           password_confirmation: 'password' }
    end

    assert_equal 2, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.approved?
    assert_not user.confirmed?
    assert_not user.admin?
  end
end
