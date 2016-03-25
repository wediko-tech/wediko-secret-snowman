class RenameRequestToGiftRequest < ActiveRecord::Migration
  def up
    rename_table :requests, :gift_requests
  end

  def down
    rename_table :gift_requests, :requests
  end
end
