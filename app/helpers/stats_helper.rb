module StatsHelper
  def home_stats
    trackers = Tracker.all
    flagged = 0

    # Count the number of fagged stories.
    trackers.each do |t|
      flagged += 1 if !t.flag.blank?
    end

    # Number of stories pitched but not yet filmed.
    pitch = Tracker.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL")
    # Number of rough cuts that haven't yet been finalzied.
    rough = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
    # Number of videos with an impact achieved
    impact = Tracker.where("impact_achieved = ?", 'yes')
    # Videos whose rough cuts have arrived from a state office and need to be cleaned, reviewed and uploaded
    goa_bank = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
    # Total approved videos whose edits haven't reached goa
    state_bank = Tracker.where("edit_received_in_goa_date IS NULL AND rough_cut_edit_date IS NOT NULL")
    # Videos on hold
    hold = Tracker.where("proceed_with_edit_and_payment = ?", 'On hold')
    # Videos uploaded to youtube
    youtube = Tracker.where("youtube_date IS NOT NULL")

    # return {trackers: trackers, flagged: flagged, pitch}
  end
end
