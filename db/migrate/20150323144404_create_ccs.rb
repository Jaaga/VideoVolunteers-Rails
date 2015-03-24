class CreateCcs < ActiveRecord::Migration
  def change
    create_table :ccs do |t|
      t.string  :full_name,       null: false
      t.string  :first_name,      null: false
      t.string  :last_name,       null: false
      t.string  :state_name,           null: false
      t.string  :state_abb,       null: false
      t.string  :district,        null: false
      t.string  :phone
      t.string  :mentor,          null: false
      t.text    :notes
      t.integer :state_id
    end
  end
end
