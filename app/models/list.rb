class List < ActiveRecord::Base
  belongs_to :therapist
  belongs_to :event
  has_many :gift_requests, dependent: :destroy

  validates :title, presence: true

  scope :empty, -> { includes(:gift_requests).where(gift_requests: {id: nil}) }
  scope :non_empty, -> { joins(:gift_requests) }
  scope :owned_by, ->(therapist) { where(therapist_id: therapist.id) }

  alias_attribute :name, :title

  ransacker :by_therapist_name,
    formatter: ->(therapist_name) {
      records = List.joins(therapist: :user).where("users.name ILIKE ?", "%#{therapist_name}%")
      records.pluck(:id).presence
    } do |parent|
      parent.table[:id]
  end

  ransacker :by_event_name,
    formatter: ->(event_name) {
      records = List.joins(:event).where("events.name ILIKE ?", "%#{event_name}%")
      records.pluck(:id).presence
    } do |parent|
      parent.table[:id]
  end

  after_create :send_creation_email

  private

  def send_creation_email
    WishlistMailer.wish_list_creation_email(self.therapist.user.id).deliver_now
  end
end
