class Reservation < ActiveRecord::Base
  belongs_to :gift_request
  belongs_to :donor

  scope :unreceived, -> { without_state(:received) }
  scope :received, -> { with_state(:received) }
  scope :reserved, -> { with_state(:reserved) }

  state_machine :initial => :reserved do
    event :ship do
      transition :reserved => :shipped
    end

    event :receive do
      transition :shipped => :received
    end

    event :cancel do
      transition :shipped => :reserved
    end
  end

  def status
    self.delinquent ? :delinquent : self.state
  end
end
