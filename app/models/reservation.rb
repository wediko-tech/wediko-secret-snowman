class Reservation < ActiveRecord::Base
  belongs_to :request
  has_one :donor

  state_machine :initial => :unreserved do
    event :reserve do
      transition :unreserved => :reserved
    end

    event :ship do
      transition :reserved => :shipped
    end

    event :receive do
      transition :shipped => :received
    end

    event :cancel do
      transition :reserved => :unreserved, :shipped => :reserved
    end
  end
end
