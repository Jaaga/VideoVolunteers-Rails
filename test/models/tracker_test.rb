require 'test_helper'

class TrackerTest < ActiveSupport::TestCase

  def setup
    @tracker = Tracker.new(uid: 'CA_456',
                           cc_name: 'Ouan Sarawut',
                           state_name: 'California',
                           iu_theme: 'Corruption',
                           description: 'Politicians taking bribes. Again.',
                           story_type: 'Entitlement Violation',
                           project: 'Oak',
                           campaign: 'Forced Evictions',
                           shoot_plan: 'Make video.',
                           story_pitch_date: '2012-12-12',
                           cc: ccs(:boss))
    @other_tracker = trackers(:CA_123)
    @other_tracker_impact = trackers(:CA_123_impact)
  end

  test "should be valid" do
    assert @tracker.valid?
  end

  test "uid should exist" do
    @tracker.uid = "     "
    assert_not @tracker.valid?
  end

  test "uid should have a maximum length" do
    @tracker.uid = 'a' * 17
    assert_not @tracker.valid?
  end

  test "uid should be unique" do
    duplicate_tracker = @tracker.dup
    duplicate_tracker.uid = @tracker.uid.upcase
    @tracker.save
    assert_not duplicate_tracker.valid?
  end

  test "state name should exist" do
    @tracker.state_name = "     "
    assert_not @tracker.valid?
  end

  test "CC name should exist" do
    @tracker.cc_name = "     "
    assert_not @tracker.valid?
  end

  test "presence should exist" do
    @validations = ['iu_theme', 'description', 'story_type', 'project',
                    'campaign', 'shoot_plan']

    @validations.each do |column|
      @tracker.send(:"#{ column }=", '   ')
      assert_not @tracker.valid?
      @tracker.send(:"#{ column }=", 'foobar')
      assert @tracker.valid?
    end

    @tracker.story_pitch_date = "    "
    assert_not @tracker.valid?
  end

  test "numericality validation should be integer" do
    @validations = ['people_involved', 'people_impacted', 'villages_impacted',
                    'screening_headcount', 'officials_at_screening_number']

    @validations.each do |column|
      @tracker.send(:"#{ column }=", 'foobar')
      assert_not @tracker.valid?
      @tracker.send(:"#{ column }=", '415')
      assert @tracker.valid?
    end
  end

  test "inclusion validation of columns with yes/no dropdowns" do
    @validations = ['high_potential', 'impact_possible', 'impact_achieved',
                    'screening_done', 'officials_at_screening',
                    'cleared_for_edit', 'impact_video_approved']

    @validations.each do |column|
      @tracker.send(:"#{ column }=", 'foobar')
      assert_not @tracker.valid?
      @tracker.send(:"#{ column }=", 'yes')
      assert @tracker.valid?
      @tracker.send(:"#{ column }=", 'no')
      assert @tracker.valid?
      @tracker.send(:"#{ column }=", '')
      assert @tracker.valid?
    end
  end

  test "district and mentor should be set" do
    @tracker.save
    assert_equal @tracker.district, @tracker.cc.district
    assert_equal @tracker.mentor, @tracker.cc.mentor
  end

  test "linked videos are unlinked before destroy (issue video)" do
    assert @other_tracker.valid?
    assert @other_tracker_impact.valid?

    @other_tracker.destroy
    assert @other_tracker_impact.reload.original_uid.blank?
    assert_not @other_tracker_impact.reload.no_original_uid.blank?
  end

  test "linked videos are unlinked before destroy (impact video)" do
    assert @other_tracker.valid?
    assert @other_tracker_impact.valid?

    @other_tracker_impact.destroy
    assert @other_tracker.reload.impact_uid.blank?
  end
end
