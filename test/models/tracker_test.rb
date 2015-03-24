require 'test_helper'

class TrackerTest < ActiveSupport::TestCase

  def setup
    @tracker = Tracker.new(uid: 'test_456',
                           cc_name: 'Ouan',
                           state_name: 'Thailand')
  end

  test "should be valid" do
    assert @tracker.valid?
  end

  test "uid should exist" do
    @tracker.uid = "     "
    assert_not @tracker.valid?
  end

  test "uid should have a maximum length" do
    @tracker.uid = 'a' * 11
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

  # test "data should be in the right case" do
  #   @tracker.assign_attributes(first_name: "stEve", last_name: "joBs",
  #                         district: "atHertoN", mentor: "zen")
  #   @tracker.save
  #   assert @tracker.first_name == "Steve"
  #   assert @tracker.last_name == "Jobs"
  #   assert @tracker.district == "Atherton"
  #   assert @tracker.mentor == "Zen"
  # end

  # test "phone should just be numbers" do
  #   @tracker.assign_attributes(phone: "(221)-123-43.54")
  #   @tracker.save
  #   assert @tracker.phone == "2211234354"
  # end
end
