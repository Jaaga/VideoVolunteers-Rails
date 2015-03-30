class AddEditStatusToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :edit_status, :string
    rename_column :trackers, :footage_location, :office_responsible
  end
end
