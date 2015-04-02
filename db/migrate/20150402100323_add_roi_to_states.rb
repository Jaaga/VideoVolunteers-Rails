class AddRoiToStates < ActiveRecord::Migration
  def change
    add_column :states, :roi, :boolean, default: false
  end
end
