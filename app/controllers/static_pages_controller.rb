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

    @stats = Array.new(25) { Array.new }
    @ccs_pitch = Array.new
    @active_states.each do |state|
      # No. of story ideas pitched
      @stats[0].push(state.trackers.where("story_pitch_date IS NOT NULL").count)
      # No. of CCs who pitched story ideas
      @stats[1].push(state.ccs.where("last_pitched_story_idea_date IS NOT NULL").count)
      # No. of CCs who made issue videos
      @stats[2].push(state.ccs.where("last_issue_video_made_date IS NOT NULL").count)
      # No. of inactive CCs who made issue videos this quarter
      @stats[3].push(state.ccs.where("is_inactive = ? AND last_issue_video_made_date > ? AND last_issue_video_made_date > ?", 'true', Time.now.months_ago(3).to_date, Time.now.to_date).count)

      # No. of story ideas pitched so far this calendar month
      @stats[4].push(state.trackers.where("story_pitch_date > ? AND story_pitch_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of story ideas pitched in the last 3 months
      @stats[5].push(state.trackers.where("story_pitch_date > ? AND story_pitch_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)
      # no of CC's who pitched a story this month
      @stats[6].push(state.ccs.where("last_pitched_story_idea_date > ? AND last_pitched_story_idea_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of CC's who pitched a story in the last 3 months
      @stats[7].push(state.ccs.where("last_pitched_story_idea_date > ? AND last_pitched_story_idea_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)

      # No of issue videos made so far this month ie raw footage received in state office
      @stats[8].push(state.trackers.where("footage_check_date > ? AND footage_check_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of issue videos made I the last 3 months ie raw footage received in state office
      @stats[9].push(state.trackers.where("footage_check_date > ? AND footage_check_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)
      # no of CC's who made an issue video this month ie raw footage received in state office
      @stats[10].push(state.ccs.where("last_issue_video_made_date > ? AND last_issue_video_made_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of CC's who made an issue video in the last three months ie raw footage received in state office
      @stats[11].push(state.ccs.where("last_issue_video_made_date > ? AND last_issue_video_made_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)

      # no of impacts achieved this month
      @stats[12].push(state.trackers.where("impact_date > ? AND impact_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of CC's who achieved an impact this month
      @stats[13].push(state.ccs.where("last_impact_achieved_date > ? AND last_impact_achieved_date < ?", Time.now.beginning_of_month.to_date, Time.now.end_of_month.to_date).count)
      # no of impacts achieved in the last 3 months
      @stats[14].push(state.trackers.where("impact_date > ? AND impact_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)
      # no of CC's who achieved an impact in the last 3 months
      @stats[15].push(state.ccs.where("last_impact_achieved_date > ? AND last_impact_achieved_date < ?", Time.now.months_ago(3).to_date, Time.now.to_date).count)

      ### State
      # videos on hold
      @stats[16].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'State', 'on hold').count)
      # State Edit Bank: total approved videos whose edits haven't reached goa (for states with regional editors only) (including on hold)
      @stats[17].push(state.trackers.where("office_responsible = ? AND production_status != ?", 'State', 'video under edit').count)
      # approved videos (everything not on hold)
      @stats[18].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'State', 'on hold').count)

      ### Goa
      # videos on hold
      @stats[19].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'HQ', 'on hold').count)
      # videos to be edited
      @stats[20].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'HQ', 'video under edit').count)
      # videos to be reviewed
      @stats[21].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'HQ', 'video under review').count)
      # videos to be finalized and uploaded
      @stats[22].push(state.trackers.where("office_responsible = ? AND production_status = ?", 'HQ', 'video to be finalised and uploaded (i.e. after review)').count)

      # Total UID's
      @stats[23].push(state.trackers.count)
      # Videos uploaded to youtube
      @stats[24].push(state.trackers.where("youtube_date IS NOT NULL").count)
    end
  end

  def about
  end

  def contact
  end

end
