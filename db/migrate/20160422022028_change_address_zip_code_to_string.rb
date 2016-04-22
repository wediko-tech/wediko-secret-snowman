class ChangeAddressZipCodeToString < ActiveRecord::Migration
  def up
    change_column :users, :address_zip_code, :string
  end

  def down
    change_column :users, :address_zip_code, :integer
  end
end
