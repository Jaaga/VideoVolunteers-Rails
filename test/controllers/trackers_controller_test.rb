require 'test_helper'

class TrackersControllerTest < ActionController::TestCase

  def setup
    @tracker = trackers(:CA_123)
    sign_in users(:test)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'td', 'Brice'
  end

  test "should get new" do
    get :new, state_name: 'California'
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracker
    assert_response :success
  end

  test "should get show" do
    get :show, id: @tracker
    assert_response :success
    assert_select 'td', 'IU Theme'
  end

  test "should get note_form" do
    get :note_form, id: @tracker
    assert_response :success
  end

  test "updated_by should be updated" do
    old_updated_by = @tracker.updated_by
    @tracker.update_attribute(:description, 'Different')
    assert_equal @tracker.description, 'Different'
    assert_not diff(@tracker.updated_by, old_updated_by) == nil
  end
end
