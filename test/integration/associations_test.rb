require 'test_helper'

class AssociationsTest < ActionDispatch::IntegrationTest

  def setup
    post new_user_session_path, user: { email: 'test@example.com',
                                        password: 'password',
                                        confirmed_at: Time.now,
                                        approved: true }
  end

  test "trackers are associated to a CC and a State" do
    post trackers_path, tracker: { cc_id: Cc.last.id,
                                   iu_theme: 'Corruption',
                                   description: 'Politicians taking bribes. Again.',
                                   story_type: 'Entitlement Violation',
                                   project: 'Oak',
                                   campaign: 'Forced Evictions',
                                   shoot_plan: 'Make video.',
                                   story_pitch_date: '2012-12-12' }
    tracker = assigns(:tracker)
    assert_equal tracker.cc_name, tracker.cc.full_name
    assert_equal tracker.state_name, tracker.state.name
  end

  test "CCs are associated with a state" do
    post ccs_path, cc: { first_name: 'Test',
                         last_name: 'Lee',
                         state_id: State.first.id,
                         district: 'Raffles',
                         mentor: 'Cambridge' }
    cc = assigns(:cc)
    assert_equal cc.state_name, cc.state.name
    assert_equal cc.state_abb, cc.state.state_abb
  end

  test "Impact actions set date for associated CC" do
    post trackers_path, tracker: { cc_id: Cc.last.id,
                                   iu_theme: 'Corruption',
                                   description: 'Politicians taking bribes. Again.',
                                   story_type: 'Entitlement Violation',
                                   project: 'Oak',
                                   campaign: 'Forced Evictions',
                                   shoot_plan: 'Make video.',
                                   story_pitch_date: '2012-12-12' }
    tracker = assigns(:tracker)

    assert tracker.cc.last_impact_action_date.blank?
    patch tracker_path(tracker), tracker: { cc_impact_action: '1' }
    assert_not tracker.reload.cc.last_impact_action_date.blank?
  end
end
