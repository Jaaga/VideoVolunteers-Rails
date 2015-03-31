class StaticPagesController < ApplicationController

  def home
    @table_head = Array.new
    @active_states = Array.new
    states = State.all
    states.each do |state|
      unless state.trackers.blank?
        @table_head.push(state.state_abb)
        @active_states.push(state)
      end
    end

    @stats = Array.new(24) { Array.new }
    @ccs_pitch = Array.new
    @active_states.each do |state|
      # No. of story ideas pitched
      @stats[0].push(state.trackers.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL").count)
      # No. of CCs who pitched story ideas
      @stats[1].push(state.ccs.where("last_pitched_story_idea_date IS NOT NULL").count)
      # No. of CCs who made issue videos
      @stats[2].push(state.ccs.where("last_issue_video_made_date IS NOT NULL").count)
      # No. of inactive CCs who made issue videos this quarter
      @stats[3].push(state.trackers.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL").count)

      # No. of story ideas pitched so far this calendar month
      @stats[4].push(state.trackers.where("story_pitch_date > ? AND story_pitch_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of story ideas pitched in the last 3 months
      @stats[5].push(state.trackers.where("story_pitch_date > ? AND story_pitch_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)
      # no of CC's who pitched a story this month
      # no of CC's who pitched a story in the last 3 months

      # No of issue videos made so far this month  ie raw footage received in state office
      # no of issue videos made I the last 3 months ie raw footage received in state office
      # no of CC's who made an issue video this monthie raw footage received in state office
      # no of CC's who made an issue video in the last three months ie raw footage received in state office

      # no of impacts achived this month
      # no of CC's who achieved an impact this month
      # no of impacts achieved in the last 3 months
      # no of CC's who achieved an impact in the last 3 months

      ### State
      # videos on hold
      @stats[16].push(state.trackers.where("office_responsible = ? AND proceed_with_edit_and_payment = ?", 'State', 'On hold').count)
      # State Edit Bank: total approved videos whose edits haven't reached goa (for states with regional editors only) (including on hold)
      # Is this redundant?
      @stats[17].push(state.trackers.where("edit_received_in_goa_date IS NULL AND proceed_with_edit_and_payment = ?", 'On hold').count)
      # approved videos
      @stats[18].push(state.trackers.where("office_responsible = ? AND proceed_with_edit_and_payment = ?", 'State', 'Cleared').count)

      ### Goa
      # videos on hold
      @stats[19].push(state.trackers.where("office_responsible = ? AND proceed_with_edit_and_payment = ?", 'Goa', 'On hold').count)
      # videos that are in Goa and need to be edited, reviewed & uploaded
      @stats[20].push(state.trackers.where("edit_received_in_goa_date IS NOT NULL AND office_responsible = ?", 'Goa').count)
      # videos whose rough cuts have arrived from a state office and need to be cleaned, reviewed and uploaded
      @stats[21].push(state.trackers.where("office_responsible = ? AND review_date IS NOT NULL", 'Goa').count)

      # Total UID's
      @stats[22].push(state.trackers.count)
      # Videos uploaded to youtube
      @stats[23].push(state.trackers.where("youtube_date IS NOT NULL").count)
    end
  end

  def about
  end

  def contact
  end

end
