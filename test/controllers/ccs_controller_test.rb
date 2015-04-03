require 'test_helper'

class CcsControllerTest < ActionController::TestCase

  def setup
    @cc = ccs(:minister)
    sign_in users(:test)
  end

  test "should get index if logged in" do
    get :index
    assert_response :success
    assert_select 'td', 'Kuan Yew Lee'
  end

  test "should not get index when logged out" do
    sign_out users(:test)
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should get new if logged in" do
    get :new
    assert_response :success
  end

  test "should not get new when logged out" do
    sign_out users(:test)
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get edit if logged in" do
    get :edit, id: @cc
    assert_response :success
  end

  test "should not get edit when logged out" do
    sign_out users(:test)
    get :edit, id: @cc
    assert_redirected_to new_user_session_path
  end

  test "should get show if logged in" do
    get :show, id: @cc
    assert_response :success
    assert_select 'td', 'Kuan Yew'
  end

  test "should not get show when logged out" do
    sign_out users(:test)
    get :show, id: @cc
    assert_redirected_to new_user_session_path
  end

  test "should get note_form if logged in" do
    get :note_form, id: @cc
    assert_response :success
  end

  test "should not get note_form when logged out" do
    sign_out users(:test)
    get :note_form, id: @cc
    assert_redirected_to new_user_session_path
  end
end
