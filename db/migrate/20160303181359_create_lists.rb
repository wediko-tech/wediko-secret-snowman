class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :therapist_id
      t.text :description
      t.string :title

      t.timestamps null: false
    end
  end
end
