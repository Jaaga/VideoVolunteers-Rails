class AddFootageRecievedToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :footage_recieved, :boolean
  end
end
