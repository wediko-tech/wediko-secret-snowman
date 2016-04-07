class RenameItemNameToName < ActiveRecord::Migration
  def change
    rename_column :gift_requests, :item_name, :name
  end
end
