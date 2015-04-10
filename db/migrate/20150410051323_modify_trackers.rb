class ModifyTrackers < ActiveRecord::Migration
  def change
    add_column    :trackers, :training_suggestion, :text
    add_column    :trackers, :raw_footage_copy_goa, :string
    rename_column :trackers, :raw_footage_review_date, :footage_check_date
    rename_column :trackers, :review_date, :rough_cut_review_date
    rename_column :trackers, :edit_status, :production_status
    remove_column :trackers, :backup_received_date
    remove_column :trackers, :cleared_for_edit
  end
end
