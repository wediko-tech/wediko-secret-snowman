class Therapist < ActiveRecord::Base
  has_one :user, as: :role
  has_many :lists
end
