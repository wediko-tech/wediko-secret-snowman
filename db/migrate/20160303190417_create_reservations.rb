class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :request_id
      t.integer :donor_id
      t.string :tracking_num
      t.boolean :delinquent
      t.string :state

      t.timestamps null: false
    end
  end
end
