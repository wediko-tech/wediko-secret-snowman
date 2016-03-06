class Request < ActiveRecord::Base
  belongs_to :list
  has_one :reservation

  validates :description, presence: true
  validates :recipient, presence: true
end
