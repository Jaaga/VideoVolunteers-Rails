class AddFieldsToCcs < ActiveRecord::Migration
  def change
    add_column :ccs, :dob, :date
    add_column :ccs, :gender, :string
    add_column :ccs, :address, :text
    add_column :ccs, :block, :string
    add_column :ccs, :pincode, :integer
    add_column :ccs, :email, :string
    add_column :ccs, :educational_qualifications, :string
    add_column :ccs, :occupation, :string
    add_column :ccs, :personal_monthly_earning, :integer
    add_column :ccs, :parents_occupation, :string
    add_column :ccs, :monthly_household_income, :integer
    add_column :ccs, :no_of_people_in_household, :integer
    add_column :ccs, :avg_income_per_person, :integer
    add_column :ccs, :social_category, :string
    add_column :ccs, :name_of_category, :string
    add_column :ccs, :religion, :string
    add_column :ccs, :social_organization_associated_with, :string
    add_column :ccs, :role_in_organization, :string
    add_column :ccs, :issue_concerned, :string
    add_column :ccs, :opinion_on_media, :string
    add_column :ccs, :operate_still_camera, :boolean, default: false
    add_column :ccs, :opearte_video_camera, :boolean, default: false
    add_column :ccs, :experience_with_camera, :string
    add_column :ccs, :have_mobile_phone, :boolean, default: false
    add_column :ccs, :phone_has_camera, :boolean, default: false
    add_column :ccs, :basic_computer_skill, :boolean, default: false
    add_column :ccs, :knows_word_processing, :boolean, default: false
    add_column :ccs, :knows_excel_processing, :boolean, default: false
    add_column :ccs, :knows_internet, :boolean, default: false
    add_column :ccs, :knows_email, :boolean, default: false
    add_column :ccs, :knows_video_editing, :boolean, default: false
    add_column :ccs, :knows_graphics_multimedia, :boolean, default: false
    add_column :ccs, :access_to_internet, :string
    add_column :ccs, :internet_access_distance, :float
    add_column :ccs, :speaking_languages, :string
    add_column :ccs, :reading_languages, :string
    add_column :ccs, :first_refrence_first_name, :string
    add_column :ccs, :first_refrence_last_name, :string
    add_column :ccs, :first_refrence_organization, :string
    add_column :ccs, :first_refrence_phone, :integer
    add_column :ccs, :first_refrence_email, :string
    add_column :ccs, :second_refrence_second_name, :string
    add_column :ccs, :second_refrence_last_name, :string
    add_column :ccs, :second_refrence_organization, :string
    add_column :ccs, :second_refrence_phone, :integer
    add_column :ccs, :second_refrence_email, :string
    add_column :ccs, :fellowship_payment_accept, :boolean, default: true
    add_column :ccs, :how_you_know_india_unheard, :text
    add_column :ccs, :can_do_a_video_a_month, :boolean, default: true
    add_column :ccs, :can_attend_training, :boolean, default: true
    add_column :ccs, :can_attend_regular_training, :boolean, default: true
    add_column :ccs, :can_attend_quarterly_meet, :boolean, default: true
    add_column :ccs, :date_applied, :date
    add_column :ccs, :program_coordinator_note, :text
    add_column :ccs, :director_note, :text
    add_column :ccs, :accepted, :string
    add_column :ccs, :status, :string
    add_column :ccs, :sac_notes, :text
  end
end
