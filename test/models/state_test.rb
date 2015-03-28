require 'test_helper'

class StateTest < ActiveSupport::TestCase
  def setup
    @state = State.new(name: "Oregon", state_abb: "OR")
    @singapore = states(:singapore)
  end

  test "should be valid" do
    assert @state.valid?
  end

  test "state name should exist" do
    @state.name = "     "
    assert_not @state.valid?
  end

  test "state name should have a maximum length" do
    @state.name = 'a' * 51
    assert_not @state.valid?
  end

  test "state name should be unique" do
    duplicate_state = @state.dup
    duplicate_state.name = @state.name.upcase
    @state.save
    assert_not duplicate_state.valid?
  end

  test "state abbreviation should exist" do
    @state.state_abb = "     "
    assert_not @state.valid?
  end

  test "state abbreviation should have a maximum length" do
    @state.state_abb = 'a' * 3
    assert_not @state.valid?
  end

  test "state abbreviation should be unique" do
    duplicate_state = @state.dup
    duplicate_state.state_abb = @state.state_abb.downcase
    @state.save
    assert_not duplicate_state.valid?
  end

  test "data should be in the right case" do
    @state.assign_attributes(name: "oregon", state_abb: "or")
    @state.save
    assert @state.name == "Oregon"
    assert @state.state_abb == "OR"
  end

  test "updating information should also update associations" do
    @singapore.update_attributes(name: "Xsingapore", state_abb: "XS")
    @singapore.ccs.each do |cc|
      assert cc.state_name == "Xsingapore"
      assert cc.state_abb == "XS"
    end
    @singapore.trackers.each do |tracker|
      tracker.state_name == "Xsingapore"
    end
  end
end
