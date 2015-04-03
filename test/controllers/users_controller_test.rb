require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'td', 'test2@example.com'
  end

  test "should not get index as non-admin or when logged out" do
    sign_out users(:admin)
    get :index
    assert_redirected_to new_user_session_path
    sign_in users(:test)
    get :index
    assert_redirected_to root_path
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should not get edit as non-admin or when logged out" do
    sign_out users(:admin)
    get :edit, id: @user
    assert_redirected_to new_user_session_path
    sign_in users(:test)
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test "should get show" do
    get :show, id: @user
    assert_response :success
    assert_select 'td', 'Email'
  end

  test "should not get show as non-admin or when logged out" do
    sign_out users(:admin)
    get :show, id: @user
    assert_redirected_to new_user_session_path
    sign_in users(:test)
    get :show, id: @user
    assert_redirected_to root_path
  end
end
