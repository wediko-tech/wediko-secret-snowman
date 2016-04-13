class List < ActiveRecord::Base
  belongs_to :therapist
  belongs_to :event
  has_many :gift_requests, dependent: :destroy

  validates :title, presence: true

  scope :empty, -> { includes(:gift_requests).where(gift_requests: {id: nil}) }
  scope :non_empty, -> { joins(:gift_requests) }
  scope :owned_by, ->(therapist) { where(therapist_id: therapist.id) }

  alias_attribute :name, :title
end
