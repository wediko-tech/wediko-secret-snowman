class Donor < ActiveRecord::Base
  include Role
  has_many :reservations
end
