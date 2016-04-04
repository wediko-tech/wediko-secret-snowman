class GiftRequest < ActiveRecord::Base
  belongs_to :list
  has_one :reservation, dependent: :destroy

  scope :reserved, -> { joins(:reservation) }
  scope :unreserved, -> { includes(:reservation).where(reservations: {id: nil}) }

  validates :description, presence: true
  validates :recipient, presence: true

  def status
    reservation.try(:status) || :unreserved
  end
end
