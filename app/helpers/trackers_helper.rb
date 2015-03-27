module TrackersHelper

  def set_uid(in_state, state_abb, tracker, is_impact = false)
    if !in_state.empty?
      # Save each UID in an array
      uids_from_state = Array.new
      in_state.each do |tracker|
        uids_from_state.push(tracker.uid)
      end

      # Sort it then save the highest number
      uids_from_state.sort!
      last_uid_from_state = uids_from_state[uids_from_state.length - 1].split('_')

      # Take the number from the split UID (looks like ['XX', '1234']), then
      # increment it
      id = last_uid_from_state[1].to_i + 1

      if is_impact == true
        unless tracker.original_uid.blank?
          id = tracker.original_uid.split('_').pop
          impact_uid_set(tracker.original_uid)
        end
        return "#{ state_abb }_#{ id.to_s }_impact"
      else
        # Make unique UID from state abbreviation and newly created number
        return "#{ state_abb }_#{ id.to_s }"
      end
    else
      if is_impact == true
        return "#{ state_abb }_1001_impact"
      else
        return "#{ state_abb }_1001"
      end
    end
  end

  # Set the uid for an impact video tracker
  def impact_uid_set(original_uid)
    track = Tracker.find_by(uid: original_uid)
    track.impact_uid = "#{ original_uid }_impact"
    track.save
  end

  def impact_edit_system(tracker)
    unless tracker.uid.include? '_impact'
      tracker.update_attribute(:uid, "#{ tracker.uid }_impact")
    end
    other_tracker = Tracker.find_by(uid: tracker.original_uid)
    other_tracker.update_attribute(:impact_uid, tracker.uid)
  end

  def remove_impact_edit_system(tracker, original_uid)
    if tracker.uid.include? '_impact'
      tracker.update_attribute(:uid, tracker.uid.sub('_impact', ''))
      tracker.update_attribute(:original_uid, nil)
      other_tracker = Tracker.find_by(uid: original_uid)
      other_tracker.update_attribute(:impact_uid, nil)
    end
  end

  def checkbox_label(columns)
    a = Hash[columns.map.with_index { |value, index| [index, tracker_name_modifier(value)] }]
    a = Hash[a.sort_by{|k, v| v}]

    8.times do |t|
      a.delete(t)
    end

    return a
  end


  # Used to capitalize each segment of names and other words along with column
  # names. If the column name won't do for display, a custom one is given in the
  # state_label method.
  def tracker_name_modifier(x)
    !tracker_label(x).nil? ? tracker_label(x) : x.split('_').map(&:capitalize).join(' ')
  end

  # Gives custom labels to the column names in the labels hash.
  def tracker_label(x)
    labels =  { 'uid' => 'UID', 'iu_theme' => 'IU Theme',
      'description' => 'Description (one-liner and later youtube blurb)',
      'screening' => 'Screening (for impact only)',
      'no_original_uid' => 'Reason for not having original UID',
      'cc_feedback' => 'Feedback to give to CC',
      'impact_possible' => 'Impact Possible?',
      'editor_changes_needed' => 'Editor changes needed?',
      'impact_plan' => 'Impact plan advised to CC',
      'impact_process' => 'CC’s actual impact process and updates',
      'milestone' => 'Milestone achieved or aimed for (when complete impact
        not likely)',
      'important_impact' => 'Important impact? (If yes, why?)',
      'screening_done' => 'Community screening done?',
      'impact_progress' => 'What was the progress?',
      'cc_last_steps_for_payment' => 'What must cc do before the video will be
        cleared for payment?',
      'officials_at_screening' => 'Screening to official done?',
      'screening_headcount' => 'Number of community members at community screening',
      'officials_involved' => 'Names of officials involved',
      'officials_at_screening_number' => 'Number of officials the video has
        been shown to',
      'instructions_for_editor_edit' => 'Instrutions for editor',
      'instructions_for_editor_final' => 'Instrutions for editor after final review',
      'editor_notes' => "Editor's notes",
      'impact_date' => 'Date impact achieved',
      'impact_time' => 'Time it took to achieve the impact',
      'collaborations' => 'Who did the CC collaborate with to get the impact?',
      'impact_video_notes' => 'Other impact video notes',
      'state_edit_date' => 'State edit date (only if there’s a state editor)',
      'rough_cut_edit_date' => 'Goa Rough Cut Edit Date (only if the raw
        footage is edited in Goa)' }

    !labels[x].nil? ? labels[x] : nil
  end
end
