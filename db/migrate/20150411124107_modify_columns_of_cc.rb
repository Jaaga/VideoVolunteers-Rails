class ModifyColumnsOfCc < ActiveRecord::Migration
  def change
  	rename_column :ccs, :opearte_video_camera, :operate_video_camera
  	remove_column :ccs, :program_coordinator_note
  	remove_column :ccs, :director_note
  	remove_column :ccs, :sac_notes
  	remove_column :ccs, :fellowship_payment_accept
  	change_column :ccs, :pincode, :string
  	change_column :ccs, :internet_access_distance, :string
  	change_column :ccs, :first_refrence_phone, :string
  	change_column :ccs, :second_refrence_phone, :string
  	change_column :ccs, :monthly_household_income, :string
  	change_column :ccs, :no_of_people_in_household, :string
  	change_column :ccs, :avg_income_per_person, :string
  	change_column :ccs, :personal_monthly_earning, :string
  end
end
