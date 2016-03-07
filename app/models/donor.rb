class Donor < ActiveRecord::Base
  has_one :user, as: :role
  has_many :reservation
end
