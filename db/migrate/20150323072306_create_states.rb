class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :state,      null: false, unique: true
      t.string :state_abb,  null: false, unique: true
      t.string :district
    end
  end
end
