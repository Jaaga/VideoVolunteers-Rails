module ArraySettingHelper

  # Return a hash of all the column names, except for 'uid', 'state_name', and
  # 'cc_name'

  def array_set
    general_info = ['cc_name', 'story_pitch_date', 'iu_theme', 'subcategory', 'description',
                    'story_type', 'project', 'campaign', 'shoot_plan',
                    'training_suggestion', 'footage_recieved', 'footage_received_from_cc_date']
    status = ['production_status', 'office_responsible', 'footage_received_from_cc_date',
              'raw_footage_copy_goa', 'footage_check_date', 'state_edit_date',
              'edit_received_in_goa_date', 'rough_cut_edit_date',
              'rough_cut_review_date', 'finalized_date', 'youtube_date',
              'iu_publish_date', 'extra_footage_received_date']
    footage_check = ['community_participation_description', 'broll', 'interview',
                        'voice_over', 'video_diary', 'p2c', 'translation_info',
                        'proceed_with_edit_and_payment', 'cc_last_steps_for_payment',
                        'call_to_action_review']
    edit = ['editor_currently_in_charge', 'folder_title',
            'instructions_for_editor_edit', 'editor_notes']
    rough_cut_review = ['reviewer_name', 'editor_changes_needed',
                      'instructions_for_editor_final',
                      'publishing_suggestions', 'cc_feedback',
                      'subtitle_info', 'high_potential']
    impact_planning = ['impact_possible', 'call_to_action', 'desired_change',
                       'impact_plan', 'target_official',
                       'target_official_email', 'target_official_phone',
                       'impact_process', 'milestone', 'impact_progress',
                       'cc_impact_action']
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
    final_video_title = ['video_title']
    url = ['youtube_url']
    extra = ['impact_uid', 'original_uid', 'no_original_uid', 'notes', 'flag',
             'flag_notes', 'flag_date', 'updated_by', 'created_at', 'updated_at']

    return { general_info: general_info, status: status,
             rough_cut_review: rough_cut_review, edit: edit, footage_check: footage_check,
             impact_planning: impact_planning, impact_achieved: impact_achieved,
             impact_video: impact_video , screening: screening, payment: payment,
             ratings: ratings, final_video_title: final_video_title, url: url,
             extra: extra }
  end

  def unique_set
    special = ['edit_status', 'office_responsible', 'iu_theme', 'subcategory',
               'story_type', 'project', 'campaign',
               'proceed_with_edit_and_payment', 'payment_status',
               'subtitle_info', 'editor_changes_needed', 'translation_info',
               'screened_on', 'impact_video_status',
               'editor_currently_in_charge', 'impact_verified_by',
               'impact_video_approved_by']
    yesno   =  ['high_potential', 'impact_possible',
                'impact_achieved', 'screening_done', 'officials_at_screening',
                'impact_video_approved', 'raw_footage_copy_goa']
    numbers =  ['people_involved', 'people_impacted', 'villages_impacted',
                'screening_headcount', 'officials_at_screening_number']

    return { special: special, yesno: yesno, numbers: numbers }
  end

  def employee_set
    sc = ['Uttar Pradesh', 'Orissa', 'Bihar', 'Jharkhand', 'Maharashtra',
          'Jammu and Kashmir', 'Chattisgarh', 'Madhya Pradesh', 'ROI']

    editor = editors_collection
    editor.collect! { |x| x[0]}

    return {sc: sc, editor: editor}
  end

end
