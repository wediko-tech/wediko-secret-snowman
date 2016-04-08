class SetReservationDelinquentDefaultAsFalse < ActiveRecord::Migration
  def change
    change_column :reservations, :delinquent, :boolean, default: false
  end
end
