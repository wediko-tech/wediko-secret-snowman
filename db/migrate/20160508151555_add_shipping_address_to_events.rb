class AddShippingAddressToEvents < ActiveRecord::Migration
  def change
    add_column :events, :address_line_1, :string
    add_column :events, :address_line_2, :string
    add_column :events, :address_city, :string
    add_column :events, :address_state, :string
    add_column :events, :address_zip_code, :integer
  end
end
