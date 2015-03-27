class StaticPagesController < ApplicationController

  def home
    @table_head = ['']
    @active_states = Array.new
    states = State.all
    states.each do |state|
      unless state.trackers.blank?
        @table_head.push(state.state_abb)
        @active_states.push(state)
      end
    end

    @stats = Array.new
    @ccs_pitch = Array.new
    @active_states.each do |state|
      # No. of story ideas pitched
      @stats.push(state.trackers.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL").count)
      # No. of story ideas pitched so far this calendar month
      # @stats.push(state.trackers.where(story_pitch_date: Date.today-14...Date.today+1))
      # no of story ideas pitched in the last 3 months
      # @stats.push()

      ### State
      # videos on hold
      @stats.push(state.trackers.where("footage_location = ? AND proceed_with_edit_and_payment = ?", 'State', 'On hold').count)
      # State Edit Bank: total approved videos whose edits haven't reached goa (for states with regional editors only) (including on hold)
      # Is this redundant?
      @stats.push(state.trackers.where("edit_received_in_goa_date IS NULL AND proceed_with_edit_and_payment = ?", 'On hold').count)
      # approved videos
      @stats.push(state.trackers.where("footage_location = ? AND proceed_with_edit_and_payment = ?", 'State', 'Cleared').count)

      ### Goa
      # videos on hold
      @stats.push(state.trackers.where("footage_location = ? AND proceed_with_edit_and_payment = ?", 'Goa', 'On hold').count)
      # videos that are in Goa and need to be edited, reviewed & uploaded
      @stats.push(state.trackers.where("edit_received_in_goa_date IS NOT NULL AND footage_location = ?", 'Goa').count)
      # videos whose rough cuts have arrived from a state office and need to be cleaned, reviewed and uploaded
      @stats.push(state.trackers.where("footage_location = ? AND review_date IS NOT NULL", 'Goa').count)

      # Total UID's
      @stats.push(state.trackers.count)
      # Videos uploaded to youtube
      @stats.push(state.trackers.where("youtube_date IS NOT NULL").count)
    end



    @track = Tracker.all
    @flag = 0

    # Count the number of fagged stories.
    @track.each do |t|
      @flag += 1 if !t.flag.blank?
    end

    # Number of stories pitched but not yet filmed.
    @pitch = Tracker.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL")
    # Number of rough cuts that haven't yet been finalzied.
    @rough = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
    # Number of videos with an impact achieved
    @impact = Tracker.where("impact_achieved = ?", 'yes')
    # Videos whose rough cuts have arrived from a state office and need to be cleaned, reviewed and uploaded
    @goa_bank = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
    # Total approved videos whose edits haven't reached goa
    @state_bank = Tracker.where("edit_received_in_goa_date IS NULL AND rough_cut_edit_date IS NOT NULL")
    # Videos on hold
    @hold = Tracker.where("proceed_with_edit_and_payment = ?", 'On hold')
    # Videos uploaded to youtube
    @youtube = Tracker.where("youtube_date IS NOT NULL")
  end

  def about
  end

  def contact
  end

end
