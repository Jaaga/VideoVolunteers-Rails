module TrackersHelper

  def set_uid(state, tracker)
      if tracker.is_impact == true
         puts "Inside impact set uid"
        if tracker.original_uid.present?
          id = "#{ state.state_abb }_#{tracker.original_uid.gsub(/[^0-9]/,"")}_impact"
          impact_uid_set(tracker.original_uid, id)
        elsif tracker.original_uid.blank?
          state.update_attribute(:counter, state.counter + 1 )
          id = "#{ state.state_abb }_#{ state.counter }_impact"
        end
      else
        state.update_attribute(:counter, state.counter + 1 )
        id = "#{ state.state_abb }_#{ state.counter}"
      end
      return id
  end

  # Set the uid for an impact video tracker
  def impact_uid_set(original_uid, id)
    track = Tracker.find_by(uid: original_uid)
    track.impact_uid = id
    track.save
  end

  def impact_edit_system(tracker)
    unless tracker.uid.include? '_impact'
      tracker.update_attribute(:uid, "#{ tracker.uid }_impact")
    end
    unless tracker.original_uid.blank?
      other_tracker = Tracker.find_by(uid: tracker.original_uid)
      other_tracker.update_attribute(:impact_uid, tracker.uid)
    end
  end

  def remove_impact_edit_system(tracker, original_uid)
    if tracker.uid.include? '_impact'
      tracker.update_attribute(:uid, tracker.uid.sub('_impact', ''))
      tracker.update_attribute(:original_uid, nil)
      unless original_uid.blank?
        other_tracker = Tracker.find_by(uid: original_uid)
        other_tracker.update_attribute(:impact_uid, nil)
      else
        tracker.update_attribute(:no_original_uid, nil)
      end
    end
  end

  # Sorts checkbox labels (in index) based on labels given to column names.
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
  # tracker_label method.
  def tracker_name_modifier(x)
    !tracker_label(x).nil? ? tracker_label(x) : x.split('_').map(&:capitalize).join(' ')
  end

  # Gives custom labels to the column names in the labels hash.
  def tracker_label(x)
    labels =  { 'uid' => 'UID', 'iu_theme' => 'IU Theme',
      'description' => 'ONE LINER (and later youtube blurb) - WHO WHEN WHERE WHAT',
      'shoot_plan' => 'Shoot plan / Notes / Extra plan',
      'edit_received_in_goa_date' => 'Rough Cut Received in Goa Date',
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
      'state_edit_date' => 'Edit date ',
      'rough_cut_edit_date' => 'Goa Rough Cut Edit Date',
      'cc_impact_action' => 'Has the CC made an impact action?',
      'training_suggestion' => 'Training Team suggestion',
      'raw_footage_copy_goa' => 'Is there a copy of the raw footage in Goa?',
      'rough_cut_review_date' => 'Rough cut review date in Goa (by SP or Comms Team)' }

    !labels[x].nil? ? labels[x] : nil
  end
end
