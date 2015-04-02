require 'test_helper'

class TrackerNoteTest < ActionDispatch::IntegrationTest

  def setup
    post new_user_session_path, user: { email: 'test@example.com',
                                        password: 'password',
                                        confirmed_at: Time.now,
                                        approved: true }
    @tracker = trackers(:CA_123)
  end

  test "should redirect if note is blank" do
    patch note_tracker_path(@tracker), tracker: { notes: "Test" }
    patch note_tracker_path(@tracker), tracker: { notes: "" }
    assert_not flash.empty?
    assert_redirected_to @tracker
    @tracker.reload
    assert_equal @tracker.notes, "#{ Date.today }: Test"
  end

  test "should add new note to tracker" do
    patch note_tracker_path(@tracker), tracker: { notes: "Test" }
    assert_not flash.empty?
    assert_redirected_to @tracker
    @tracker.reload
    assert_equal @tracker.notes, "#{ Date.today }: Test"
  end

  test "should add note to existing notes on tracker" do
    patch note_tracker_path(@tracker), tracker: { notes: "Test" }
    patch note_tracker_path(@tracker), tracker: { notes: "New line" }
    assert_not flash.empty?
    assert_redirected_to @tracker
    @tracker.reload
    assert_equal @tracker.notes, "#{ Date.today }: New line\n#{ Date.today }: Test"
  end
end
