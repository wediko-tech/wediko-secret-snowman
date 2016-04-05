class AddEventsToLists < ActiveRecord::Migration
  def change
    add_column :lists, :event_id, :integer
    add_reference :lists, :events, index: true, foreign_key: true
  end
end
