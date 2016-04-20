class RenameTrackingNumToTrackingNumber < ActiveRecord::Migration
  def change
    rename_column :reservations, :tracking_num, :tracking_number
  end
end
