require 'test_helper'

class StatesControllerTest < ActionController::TestCase

  def setup
    @state = states(:california)
    sign_in users(:test)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'td', 'California'
  end

  test "should not get index when logged out" do
    sign_out users(:test)
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get new when logged out" do
    sign_out users(:test)
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    get :edit, id: @state
    assert_response :success
  end

  test "should not get edit when logged out" do
    sign_out users(:test)
    get :edit, id: @state
    assert_redirected_to new_user_session_path
  end

  test "should get show" do
    get :show, id: @state
    assert_response :success
    assert_select 'td', 'California'
  end

  test "should not get show when logged out" do
    sign_out users(:test)
    get :show, id: @state
    assert_redirected_to new_user_session_path
  end
end
