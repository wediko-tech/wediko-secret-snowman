class RemoveNameFieldFromGiftRequest < ActiveRecord::Migration
  def change
    remove_column :gift_requests, :name, :string
  end
end
