class AddRoughCutSentToGoaToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :rough_cut_sent_to_goa, :boolean, default: false
    add_column :trackers, :rough_cut_sent_to_goa_date, :date
  end
end
