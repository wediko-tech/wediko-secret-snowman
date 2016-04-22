class AddAddressFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :address_line_1, :string
    add_column :users, :address_line_2, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_zip_code, :integer
  end
end
