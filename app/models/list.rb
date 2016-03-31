class List < ActiveRecord::Base
  belongs_to :therapist
  has_many :gift_requests, dependent: :destroy

  validates :description, presence: true
  validates :title, presence: true

  scope :empty, -> { includes(:gift_requests).where(gift_requests: {id: nil}) }
  scope :non_empty, -> { joins(:gift_requests) }

  alias_attribute :name, :title
end
