require 'test_helper'

class CcTest < ActiveSupport::TestCase
  def setup
    @cc = Cc.new(full_name: 'Steve Jobs',
                 first_name: 'Steve',
                 last_name: 'Jobs',
                 state_name: 'California',
                 state_abb: 'CA',
                 district: 'Atherton',
                 mentor: 'Zen',
                 state: states(:california))

    @minister = ccs(:minister)
  end

  test "should be valid" do
    assert @cc.valid?
  end

  test "cc name should exist" do
    @cc.full_name = "Steve Jobs"
    @cc.first_name = "     "
    assert_not @cc.valid?
    @cc.first_name = "Steve"
    @cc.last_name = "     "
    assert_not @cc.valid?
  end

  test "cc name should have a maximum length" do
    @cc.first_name = 'a' * 51
    assert_not @cc.valid?
    @cc.first_name = 'a' * 50
    @cc.last_name = 'a' * 51
    assert_not @cc.valid?
  end

  test "state name should exist" do
    @cc.state_name = "     "
    assert_not @cc.valid?
  end

  test "cc district should exist" do
    @cc.district = "     "
    assert_not @cc.valid?
  end

  test "cc district should have a maximum length" do
    @cc.district = 'a' * 51
    assert_not @cc.valid?
  end

  test "cc phone should have a maximum length" do
    @cc.phone = 'a' * 61
    assert_not @cc.valid?
  end

  test "cc mentor should exist" do
    @cc.mentor = "     "
    assert_not @cc.valid?
  end

  test "cc mentor should have a maximum length" do
    @cc.mentor = 'a' * 51
    assert_not @cc.valid?
  end

  test "data should be in the right case" do
    @cc.assign_attributes(first_name: "stEve", last_name: "joBs",
                          district: "atHertoN", mentor: "zen")
    @cc.save
    assert @cc.first_name == "Steve"
    assert @cc.last_name == "Jobs"
    assert @cc.district == "Atherton"
    assert @cc.mentor == "Zen"
  end

  test "full name should be set" do
    @cc.assign_attributes(first_name: "bill", last_name: "gates")
    @cc.save
    assert @cc.full_name == "Bill Gates"
  end

  test "phone should just be numbers" do
    @cc.assign_attributes(phone: "+e(221)-123-43.54")
    @cc.save
    assert @cc.phone == "2211234354"
  end

  test "updating information should also update associations" do
    @minister.update_attributes(first_name: "Kuan", last_name: "Yee",
                                state_name: "California")

    @minister.trackers.each do |tracker|
      assert tracker.cc_name == "Kuan Yee"
    end

    assert @minister.state.name == "California"
  end
end
