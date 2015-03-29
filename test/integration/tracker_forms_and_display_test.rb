require 'test_helper'

class TrackerFormsAndDisplayTest < ActionDispatch::IntegrationTest

  def setup
    @tracker = trackers(:CA_123)
    @tracker_impact = trackers(:CA_123_impact)
  end

  test "non-impact tracker doesn't display impact information" do
    get tracker_path(@tracker)
    assert_select 'h2', { count:0, text: 'Impact Planning'}
    assert_select 'h2', { count:0, text: 'Impact Achieved'}
    assert_select 'h2', { count:0, text: 'Impact Video'}
    get edit_tracker_path(@tracker)
    assert_select 'h2', { count:0, text: 'Impact Planning'}
    assert_select 'h2', { count:0, text: 'Impact Achieved'}
    assert_select 'h2', { count:0, text: 'Impact Video'}
  end

  test "impact tracker displays impact information" do
    get tracker_path(@tracker_impact)
    assert_select 'h2', 'Impact Planning'
    assert_select 'h2', 'Impact Achieved'
    assert_select 'h2', 'Impact Video'
    get edit_tracker_path(@tracker_impact)
    assert_select 'h2', 'Impact Planning'
    assert_select 'h2', 'Impact Achieved'
    assert_select 'h2', 'Impact Video'
  end
end
