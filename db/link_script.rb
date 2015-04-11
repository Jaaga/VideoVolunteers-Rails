# Link the CCs to their respective state
def cc_link
  ccs = Cc.all
  ccs.each do |cc|
    state = State.find_by(state_abb: cc.state_abb)
    cc.update_attribute(:state, state)
  end
end

# Link the trackers to their respective CC and state
def tracker_link
  trackers = Tracker.all
  trackers.each do |tracker|
    cc = Cc.find_by(full_name: tracker.cc_name)
    state = cc.state
    tracker.update_attribute(:state, state)
    tracker.update_attribute(:cc, cc)
  end
end

# Change cc_name in batch
def change_name
  trackers = Tracker.all
  trackers.each do |tracker|
    tracker.update_attribute(:cc_name, tracker.cc_name.split.map(&:capitalize).join(' '))
  end
end

# Give temporary dates to all the CCs so that associated_dates_refresh can
# trigger the tracker models after_save
def temp_cc_dates
  ccs = Cc.all
  ccs.each do |cc|
    x = '2000-01-01'
    cc.update_attributes(last_pitched_story_idea_date: x,
                         last_issue_video_made_date: x,
                         last_issue_video_sent_date: x)
  end
end

# Set the CC dates
def associated_dates_refresh
  trackers = Tracker.all
  trackers.each do |tracker|
    if !tracker.story_pitch_date.blank? && (tracker.cc.last_pitched_story_idea_date < tracker.story_pitch_date)
      tracker.cc.assign_attributes(last_pitched_story_idea_date: tracker.story_pitch_date)
    end
    if !tracker.footage_check_date.blank? && (tracker.cc.last_issue_video_made_date < tracker.footage_check_date)
      tracker.cc.assign_attributes(last_issue_video_made_date: tracker.footage_check_date)
    end
    if tracker.impact_achieved == 'yes'
      tracker.cc.assign_attributes(last_impact_achieved_date: Date.today)
    end
    if !tracker.footage_received_from_cc_date.blank? && (tracker.cc.last_issue_video_sent_date < tracker.footage_received_from_cc_date)
      tracker.cc.assign_attributes(last_issue_video_sent_date: tracker.footage_received_from_cc_date)
    end
    if tracker.impact_video_status == 'Completed'
      tracker.cc.assign_attributes(last_impact_video_made_date: Date.today)
    end

    tracker.cc.save
  end
end


# Remove the temporary dates set
def remove_temp_cc_dates
  ccs = Cc.all
  ccs.each do |cc|
    x = '2000-01-01'
    if cc.last_pitched_story_idea_date.to_s == x
      cc.update_attribute(:last_pitched_story_idea_date, '')
    end
    if cc.last_issue_video_made_date.to_s == x
      cc.update_attribute(:last_issue_video_made_date, '')
    end
    if cc.last_issue_video_sent_date.to_s == x
      cc.update_attribute(:last_issue_video_sent_date, '')
    end
  end
end


# Set is_impact based on if a uid has '_impact' in the uid
def is_impact
  trackers = Tracker.all
  trackers.each do |tracker|
    if tracker.uid.include? '_impact'
      tracker.update_attribute(:is_impact, '1')
      if tracker.original_uid.blank?
        tracker.update_attribute(:no_original_uid, "No Original ID")
      end
    end
  end
end
