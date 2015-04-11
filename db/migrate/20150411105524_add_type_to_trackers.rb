class AddTypeToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :type, :string, default: "Story"
  end
end
