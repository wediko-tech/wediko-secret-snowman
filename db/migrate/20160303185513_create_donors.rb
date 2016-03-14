class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|

      t.timestamps null: false
    end
  end
end
