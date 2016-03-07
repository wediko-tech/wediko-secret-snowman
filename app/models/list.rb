class List < ActiveRecord::Base
  belongs_to :therapist
  has_many :requests

  validates :description, presence: true
  validates :title, presence: true
end
