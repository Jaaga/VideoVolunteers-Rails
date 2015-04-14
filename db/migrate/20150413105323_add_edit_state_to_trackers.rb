class AddEditStateToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :edit_status, :string
  end
end
