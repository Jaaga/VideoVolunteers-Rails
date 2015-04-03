require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    sign_in users(:test)
  end

  test "should get home" do
    get :home
    assert_response :success
  end

  test "should not get home when logged out" do
    sign_out users(:test)
    get :home
    assert_redirected_to new_user_session_path
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should not get about when logged out" do
    sign_out users(:test)
    get :about
    assert_redirected_to new_user_session_path
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should not get contact when logged out" do
    sign_out users(:test)
    get :contact
    assert_redirected_to new_user_session_path
  end
end
