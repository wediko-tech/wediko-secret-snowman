class AddNameAndCategoryToRequest < ActiveRecord::Migration
  def change
    add_column :gift_requests, :item_name, :string
    add_column :gift_requests, :category, :string
  end
end
