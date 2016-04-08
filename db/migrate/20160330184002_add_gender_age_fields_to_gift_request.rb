class AddGenderAgeFieldsToGiftRequest < ActiveRecord::Migration
  def change
    add_column :gift_requests, :gender, :string
    add_column :gift_requests, :age, :integer
  end
end
