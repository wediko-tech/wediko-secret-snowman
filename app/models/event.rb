class Event < ActiveRecord::Base
  has_many :lists, dependent: :destroy

  validates :title, presence: true
  validate :start_date_before_end_date?

  def start_date_before_end_date?
    if end_date && start_date
      errors.add(:end_date, "Event can't end before start date") if end_date < start_date
    end
  end

  alias_attribute :name, :title
end
