require 'test_helper'

class StateTest < ActiveSupport::TestCase
  def setup
    @state = State.new(state: "Oregon", state_abb: "OR",
                       district: "Portlandia")
  end

  test "should be valid" do
    assert @state.valid?
  end

  test "state name should exist" do
    @state.state = "     "
    assert_not @state.valid?
  end

  test "state name should have a maximum length" do
    @state.state = 'a' * 51
    assert_not @state.valid?
  end

  test "state name should be unique" do
    duplicate_state = @state.dup
    duplicate_state.state = @state.state.upcase
    @state.save
    assert_not duplicate_state.valid?
  end

  test "state abbreviation should exist" do
    @state.state_abb = "     "
    assert_not @state.valid?
  end

  test "state abbreviation should have a maximum length" do
    @state.state_abb = 'a' * 6
    assert_not @state.valid?
  end

  test "state abbreviation should be unique" do
    duplicate_state = @state.dup
    duplicate_state.state_abb = @state.state_abb.downcase
    @state.save
    assert_not duplicate_state.valid?
  end

  test "district doesn't have to exist" do
    @state.district = "     "
    assert @state.valid?
  end

  test "district name should have a maximum length" do
    @state.state = 'a' * 51
    assert_not @state.valid?
  end

  test "data should be in the right case" do
    @state.assign_attributes(state: "oregon", state_abb: "or",
                             district: "portlandia")
    @state.save
    assert @state.state == "Oregon"
    assert @state.state_abb == "OR"
    assert @state.district == "Portlandia"
  end
end
