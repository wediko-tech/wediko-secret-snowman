class AddShipmentMethodToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :shipment_method, :string
  end
end
