require 'test_helper'

class ImpactLinksTest < ActionDispatch::IntegrationTest

  def setup
    @tracker_120 = trackers(:CA_120)
    @tracker_120.save
    post trackers_path, tracker: { cc_id: '1056859706',
                                   iu_theme: 'Corruption',
                                   description: 'Politicians taking bribes. Again.',
                                   story_type: 'Entitlement Violation',
                                   project: 'Oak',
                                   campaign: 'Forced Evictions',
                                   shoot_plan: 'Make video.',
                                   story_pitch_date: '2012-12-12' }
    @tracker_121 = assigns(:tracker)
  end

  test "errors while setting impact link(1)" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '1',
                                                 original_uid: @tracker_120.uid,
                                                 no_original_uid: 'Test' }
    assert_not flash.empty?
    assert_template 'trackers/_forms'
    assert @tracker_121.is_impact == nil
    assert @tracker_121.original_uid == nil
    assert @tracker_121.no_original_uid == nil
  end

  test "errors while setting impact link(2)" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '1',
                                                 original_uid: nil,
                                                 no_original_uid: nil }
    assert_not flash.empty?
    assert_template 'trackers/_forms'
    assert @tracker_121.is_impact == nil
    assert @tracker_121.original_uid == nil
    assert @tracker_121.no_original_uid == nil
  end

  test "errors while setting impact link(3)" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '0',
                                                 original_uid: @tracker_120.uid,
                                                 no_original_uid: 'Test' }
    assert_not flash.empty?
    assert_template 'trackers/_forms'
    assert @tracker_121.is_impact == nil
    assert @tracker_121.original_uid == nil
    assert @tracker_121.no_original_uid == nil
  end

  test "errors while setting impact link(4)" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '0',
                                                 original_uid: nil,
                                                 no_original_uid: 'Test' }
    assert_not flash.empty?
    assert_template 'trackers/_forms'
    assert @tracker_121.is_impact == nil
    assert @tracker_121.original_uid == nil
    assert @tracker_121.no_original_uid == nil
  end

  test "errors while setting impact link(5)" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '0',
                                                 original_uid: @tracker_120.uid,
                                                 no_original_uid: nil }
    assert_not flash.empty?
    assert_template 'trackers/_forms'
    assert @tracker_121.is_impact == nil
    assert @tracker_121.original_uid == nil
    assert @tracker_121.no_original_uid == nil
  end

  test "set impact link" do
    assert_not @tracker_121.uid.include? '_impact'
    assert @tracker_120.impact_uid == nil

    patch tracker_path(@tracker_121), tracker: { is_impact: '1',
                                                 original_uid: @tracker_120.uid }
    assert @tracker_121.reload.uid.include? '_impact'
    assert_equal @tracker_120.reload.impact_uid, @tracker_121.uid
  end

  test "break impact link" do
    patch tracker_path(@tracker_121), tracker: { is_impact: '1',
                                                 original_uid: @tracker_120.uid }
    assert @tracker_121.reload.uid.include? '_impact'
    assert_equal @tracker_120.reload.impact_uid, @tracker_121.uid

    patch tracker_path(@tracker_121), tracker: { is_impact: '0' }
    assert_not @tracker_121.reload.uid.include? '_impact'
    assert @tracker_121.original_uid == nil
    assert @tracker_120.reload.impact_uid == nil
  end
end
