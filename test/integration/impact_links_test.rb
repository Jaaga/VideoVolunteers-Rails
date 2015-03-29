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
