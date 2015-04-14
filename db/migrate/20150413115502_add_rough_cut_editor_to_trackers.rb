class AddRoughCutEditorToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :rough_cut_editor, :string
    add_column :trackers, :rough_cut_reviewed, :boolean, default: false
    add_column :trackers, :uploaded, :boolean, default: false
  end
end
