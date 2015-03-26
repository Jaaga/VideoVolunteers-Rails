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

  # Return a hash of all the column names, except for 'uid', 'state_name', and
  # 'cc_name'
  def array_set
    story = ['iu_theme', 'subcategory', 'description', 'story_type', 'project',
             'campaign', 'shoot_plan', 'story_pitch_date']
    status = ['footage_location', 'footage_received_from_cc_date',
              'raw_footage_review_date', 'state_edit_date',
              'edit_received_in_goa_date', 'rough_cut_edit_date',
              'review_date', 'finalized_date', 'youtube_date',
              'iu_publish_date', 'backup_received_date',
              'extra_footage_received_date']
    raw_review = ['community_participation_description', 'broll', 'interview',
              'voice_over', 'video_diary', 'p2c', 'translation_info',
              'proceed_with_edit_and_payment', 'cc_last_steps_for_payment',
              'call_to_action_review']
    footage_edit = ['editor_currently_in_charge', 'folder_title',
                    'instructions_for_editor_edit', 'editor_notes']
    footage_review = ['reviewer_name', 'editor_changes_needed',
                      'instructions_for_editor_final',
                      'publishing_suggestions', 'cc_feedback',
                      'subtitle_info', 'high_potential',
                      'youtube_url', 'video_title', 'cleared_for_edit']
    impact_planning = ['impact_possible', 'call_to_action', 'desired_change',
                       'impact_plan', 'target_official',
                       'target_official_email', 'target_official_phone',
                       'impact_process', 'milestone', 'impact_progress']
    impact_achieved = ['impact_achieved', 'impact_achieved_description',
                       'impact_date', 'impact_verified_by', 'people_involved',
                       'people_impacted', 'villages_impacted','impact_time',
                       'collaborations', 'important_impact']
    impact_video = ['impact_video_status', 'impact_video_necessities',
                    'impact_video_approved', 'impact_video_approved_by',
                    'impact_video_notes']
    screening = ['screening_done', 'screened_on', 'officials_at_screening',
                 'screening_headcount', 'officials_at_screening_number',
                 'officials_involved', 'screening_details']
    payment = ['payment_status']
    ratings = ['footage_rating', 'final_video_rating']
    extra = ['impact_uid', 'original_uid', 'no_original_uid', 'notes', 'flag',
             'flag_notes', 'flag_date', 'updated_by', 'created_at', 'updated_at']

    return { story: story, status: status, footage_edit: footage_edit,
             footage_review: footage_review, raw_review: raw_review,
             impact_planning: impact_planning, impact_achieved: impact_achieved,
             impact_video: impact_video , screening: screening, payment: payment,
             ratings: ratings, extra: extra }
  end

  def unique_set
    special = ['footage_location', 'iu_theme', 'subcategory', 'story_type',
               'project', 'campaign',
               'proceed_with_edit_and_payment', 'payment_status',
               'subtitle_info', 'editor_changes_needed', 'translation_info',
               'screened_on', 'impact_video_status',
               'editor_currently_in_charge', 'impact_verified_by',
               'impact_video_approved_by', 'reviewer_name']
    yesno   =  ['high_potential', 'impact_possible',
               'impact_achieved', 'screening_done', 'officials_at_screening',
               'cleared_for_edit', 'impact_video_approved']
    numbers =  ['people_involved', 'people_impacted', 'villages_impacted',
               'screening_headcount', 'officials_at_screening_number']

    return { special: special, yesno: yesno, numbers: numbers }
  end
end
