class Therapist < ActiveRecord::Base
  include Role
  has_many :lists, dependent: :destroy
  has_many :gift_requests, through: :lists
end
