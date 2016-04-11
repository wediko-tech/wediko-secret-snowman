class Donor < ActiveRecord::Base
  include Role
  has_many :reservations, dependent: :destroy


end
