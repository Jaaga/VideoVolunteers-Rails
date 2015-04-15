class AddPaymentClearedDateToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :proceed_with_edit_and_payment_date, :date
    add_column :trackers, :payment_date, :date
  end
end
