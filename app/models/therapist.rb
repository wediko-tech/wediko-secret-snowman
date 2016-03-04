class Therapist < ActiveRecord::Base
  has_many :users, as: :role
  has_many :lists
end
