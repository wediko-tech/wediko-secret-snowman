class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :list_id
      t.string :recipient
      t.text :description
      t.string :link

      t.timestamps null: false
    end
  end
end
