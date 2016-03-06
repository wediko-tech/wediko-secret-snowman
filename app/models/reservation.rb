class Reservation < ActiveRecord::Base
  belongs_to :request
  has_one :donor

  state_machine :initial => :unreserved do
    event :reserved do
      transition :unreserved => :reserved
    end

    event :shipped do
      transition :reserved => :shipped
    end

    event :received do
      transition :shipped => :received
    end

    event :cancel do
      transition :reserved => :unreserved, :shipped => :reserved
    end
  end
end
