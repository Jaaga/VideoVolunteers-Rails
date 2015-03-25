class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string   :uid,                                null: false, unique: true
      t.string   :state_name,                         null: false
      t.string   :cc_name,                            null: false
      t.string   :district
      t.string   :mentor
      t.string   :iu_theme
      t.string   :subcategory
      t.text     :description
      t.string   :story_type
      t.text     :shoot_plan
      t.string   :footage_rating
      t.date     :story_pitch_date
      t.string   :editor_currently_in_charge
      t.string   :proceed_with_edit_and_payment
      t.string   :payment_status
      t.string   :folder_title
      t.string   :youtube_url
      t.string   :video_title
      t.string   :subtitle_info
      t.string   :project
      t.string   :reviewer_name
      t.string   :editor_changes_needed
      t.text     :instructions_for_editor_edit
      t.string   :high_potential
      t.text     :community_participation_description
      t.text     :broll
      t.text     :interview
      t.text     :voice_over
      t.text     :video_diary
      t.text     :p2c
      t.text     :cc_feedback
      t.text     :publishing_suggestions
      t.string   :final_video_rating
      t.date     :footage_received_from_cc_date
      t.date     :story_date
      t.date     :raw_footage_review_date
      t.date     :backup_received_date
      t.date     :state_edit_date
      t.date     :edit_received_in_goa_date
      t.date     :rough_cut_edit_date
      t.date     :review_date
      t.date     :finalized_date
      t.date     :youtube_date
      t.date     :iu_publish_date
      t.string   :impact_possible
      t.string   :target_official
      t.string   :target_official_email
      t.string   :target_official_phone
      t.text     :desired_change
      t.text     :impact_plan
      t.string   :impact_uid
      t.string   :original_uid
      t.text     :impact_process
      t.text     :impact_video_notes
      t.string   :important_impact
      t.string   :impact_achieved
      t.text     :impact_achieved_description
      t.text     :milestone
      t.string   :impact_time
      t.string   :collaborations
      t.string   :people_involved
      t.string   :people_impacted
      t.string   :villages_impacted
      t.date     :impact_date
      t.string   :screening_done
      t.string   :screening_headcount
      t.text     :screening_details
      t.string   :officials_involved
      t.string   :officials_at_screening_number
      t.string   :officials_at_screening
      t.string   :flag
      t.string   :flag_notes
      t.date     :flag_date
      t.text     :notes
      t.string   :updated_by
      t.string   :campaign
      t.date     :extra_footage_received_date
      t.text     :call_to_action
      t.text     :translation_info
      t.string   :impact_verified_by
      t.string   :no_original_uid
      t.string   :screened_on
      t.text     :editor_notes
      t.string   :cleared_for_edit
      t.string   :impact_progress
      t.string   :cc_last_steps_for_payment
      t.string   :instructions_for_editor_final
      t.string   :impact_video_status
      t.text     :impact_video_necessities
      t.string   :impact_video_approved
      t.string   :impact_video_approved_by
      t.text     :call_to_action_review
      t.string   :footage_location

      t.integer  :tracker_details_id
      t.string   :tracker_details_type

      t.timestamps  null: true
    end

    add_index :trackers, :uid, unique: true
  end
end
