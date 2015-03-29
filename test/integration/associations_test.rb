require 'test_helper'

class AssociationsTest < ActionDispatch::IntegrationTest

  test "trackers are associated to a CC and a State" do
    post trackers_path, tracker: { cc_name: '1056859706',
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
                         state_id: '46965933',
                         district: 'Raffles',
                         mentor: 'Cambridge' }
    cc = assigns(:cc)
    assert_equal cc.state_name, cc.state.name
    assert_equal cc.state_abb, cc.state.state_abb
  end
end
