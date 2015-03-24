class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name,      null: false, unique: true
      t.string :state_abb,  null: false, unique: true
    end
  end
end
