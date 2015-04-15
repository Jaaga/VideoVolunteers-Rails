class AddRoughCutCleanedToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :rough_cut_cleaned, :boolean, default: false
  end
end
