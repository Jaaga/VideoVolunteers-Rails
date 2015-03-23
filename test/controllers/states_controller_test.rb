require 'test_helper'

class StatesControllerTest < ActionController::TestCase

  def setup
    @state = states(:california)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'td', 'California'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @state
    assert_response :success
  end

  test "should get show" do
    get :show, id: @state
    assert_response :success
    assert_select 'td', 'California'
  end

end
