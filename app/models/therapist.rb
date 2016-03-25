class Therapist < ActiveRecord::Base
  include Role
  has_many :lists
end
