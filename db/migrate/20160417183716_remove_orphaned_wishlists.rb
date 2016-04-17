class RemoveOrphanedWishlists < ActiveRecord::Migration
  def change
    List.where(event_id: nil).destroy_all
  end
end
