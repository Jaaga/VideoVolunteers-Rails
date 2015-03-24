require 'test_helper'

class CcsControllerTest < ActionController::TestCase
  
  def setup
    @cc = ccs(:minister)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'td', 'Kuan Yew Lee'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cc
    assert_response :success
  end

  test "should get show" do
    get :show, id: @cc
    assert_response :success
    assert_select 'td', 'Kuan Yew'
  end
end
