class RenameTypeofTrackers < ActiveRecord::Migration
  def change
  	rename_column :trackers, :type , :tracker_type
  end
end
