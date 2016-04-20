class GiftRequest < ActiveRecord::Base
  belongs_to :list
  has_one :reservation, dependent: :destroy

  scope :reserved, -> { joins(:reservation) }
  scope :unreserved, -> { includes(:reservation).where(reservations: {id: nil}) }

  validates :name, presence: true
  validates :age, presence: true
  validates :recipient, presence: true

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
