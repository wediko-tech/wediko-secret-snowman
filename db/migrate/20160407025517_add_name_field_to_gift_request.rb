class AddNameFieldToGiftRequest < ActiveRecord::Migration
  def change
    add_column :gift_requests, :name, :string
  end
end
