class AddCounterToState < ActiveRecord::Migration
  def change
    add_column :states, :counter, :integer, default: 1000
  end
end
