class ChangeReservationGiftRequestAssociation < ActiveRecord::Migration
  def change
    rename_column :reservations, :request_id, :gift_request_id
  end
end
