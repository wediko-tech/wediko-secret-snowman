class Reservation < ActiveRecord::Base
  belongs_to :gift_request
  belongs_to :donor

  scope :unreceived, -> { without_state(:received) }
  scope :received, -> { with_state(:received) }
  scope :reserved, -> { with_state(:reserved) }
  scope :notable, -> do
    includes(gift_request: {list: :event}).where("reservations.state <> 'received' OR events.end_date > ?", Date.today)
  end

  state_machine :initial => :reserved do
    state :shipped do
      validates :shipment_method, presence: true
      validates :tracking_number, presence: true
    end

    event :ship do
      transition :reserved => :shipped
    end

    event :receive do
      transition :shipped => :received
    end

    event :cancel do
      transition :shipped => :reserved
    end

    after_transition any => :reserved do |reservation, transition|
      reservation.update_attributes(tracking_number: nil, shipment_method: nil)
    end
  end

  def status
    self.delinquent ? :delinquent : self.state
  end
end
