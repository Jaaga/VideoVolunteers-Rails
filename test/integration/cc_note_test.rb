require 'test_helper'

class CcNoteTest < ActionDispatch::IntegrationTest

  def setup
    post new_user_session_path, user: { email: 'test@example.com',
                                        password: 'password',
                                        confirmed_at: Time.now,
                                        approved: true }
    @cc = ccs(:minister)
  end

  test "should redirect if note is blank" do
    patch note_cc_path(@cc), cc: { notes: "Test" }
    patch note_cc_path(@cc), cc: { notes: "" }
    assert_not flash.empty?
    assert_redirected_to @cc
    @cc.reload
    assert_equal @cc.notes, "#{ Date.today }: Test"
  end

  test "should add new note to cc" do
    patch note_cc_path(@cc), cc: { notes: "Test" }
    assert_not flash.empty?
    assert_redirected_to @cc
    @cc.reload
    assert_equal @cc.notes, "#{ Date.today }: Test"
  end

  test "should add note to existing notes on cc" do
    patch note_cc_path(@cc), cc: { notes: "Test" }
    patch note_cc_path(@cc), cc: { notes: "New line" }
    assert_not flash.empty?
    assert_redirected_to @cc
    @cc.reload
    assert_equal @cc.notes, "#{ Date.today }: New line\n#{ Date.today }: Test"
  end
end
