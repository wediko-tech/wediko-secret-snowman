class GiftRequest < ActiveRecord::Base
  belongs_to :list
  has_one :reservation, dependent: :destroy

  scope :reserved, -> { joins(:reservation) }
  scope :unreserved, -> { includes(:reservation).where(reservations: {id: nil}) }
  scope :active_event, -> { joins(list: :event).where("? BETWEEN events.start_date AND events.end_date", Date.today) }
  scope :inactive_event, -> { joins(list: :event).where("? < events.start_date OR ? > events.end_date", Date.today, Date.today) }

  validates :name, presence: true
  validates :age, presence: true
  # gender can be male, female, or unspecified
  validates :gender, presence: true, inclusion: { in: %w(M F U) }
  validates :recipient, presence: true

  ransacker :by_wishlist_title,
    formatter: ->(wishlist_title) {
      records = GiftRequest.joins(:list).where("lists.title ILIKE ?", "%#{wishlist_title}%")
      records.pluck(:id).presence
    } do |parent|
      parent.table[:id]
  end

  def status
    reservation.try(:status) || :unreserved
  end

  private

  # if the product's link has changed to an amazon link, run a job to
  # fetch its info from amazon's api
  def update_product_api_info
    if self.link_changed? && AmazonProductApi.amazon_link?(self.link)
      AmazonApiFetcher.perform_async(self.id)
    end

    # always return true to avoid interrupting callback chain
    true
  end
end
