require 'test_helper'

class UidSetTest < ActionDispatch::IntegrationTest

  # test "new non-impact uid is set"

  test "non-impact uid is set" do
    assert_equal Tracker.last.uid, 'CA_123'
    post trackers_path, tracker: { cc_id: Cc.last.id,
                                   iu_theme: 'Corruption',
                                   description: 'Politicians taking bribes. Again.',
                                   story_type: 'Entitlement Violation',
                                   project: 'Oak',
                                   campaign: 'Forced Evictions',
                                   shoot_plan: 'Make video.',
                                   story_pitch_date: '2012-12-12' }
    tracker = assigns(:tracker)
    assert_equal tracker.uid, 'CA_124'
  end

  # test "new impact uid set"

  test "impact uid is set" do
    post trackers_path, tracker: { cc_id: Cc.last.id,
                                   iu_theme: 'Corruption',
                                   description: 'Politicians taking bribes. Again.',
                                   story_type: 'Entitlement Violation',
                                   project: 'Oak',
                                   campaign: 'Forced Evictions',
                                   shoot_plan: 'Make video.',
                                   story_pitch_date: '2012-12-12',
                                   is_impact: '1',
                                   original_uid: 'CA_120'}
    tracker = assigns(:tracker)
    issue_tracker = Tracker.find_by(uid: tracker.original_uid)
    assert_equal tracker.uid, 'CA_120_impact'
    assert_equal issue_tracker.impact_uid, tracker.uid
  end
end
