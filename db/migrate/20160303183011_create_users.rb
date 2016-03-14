class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :role, index: true
      t.string :name
      t.string :role_type

      t.timestamps null: false
    end
  end
end
