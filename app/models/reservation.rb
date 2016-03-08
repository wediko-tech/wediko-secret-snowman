class Reservation < ActiveRecord::Base
  belongs_to :request
  has_one :donor

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
end
