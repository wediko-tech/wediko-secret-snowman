class SwitchEventZipToString < ActiveRecord::Migration
  def up
    change_column :events, :address_zip_code, :string
  end

  def down
    change_column :events, :address_zip_code, :integer
  end
end
