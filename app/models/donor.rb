class Donor < ActiveRecord::Base
  has_many :users, as: :role
  has_many :reservation
end
