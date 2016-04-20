class User < ActiveRecord::Base
  include HasRole
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable
  belongs_to :role, polymorphic: true, dependent: :destroy

  # see concerns/has_role.rb for more detail
  role_predicates "administrator", "therapist", "donor"

  scope :therapists, -> { where(role_type: "Therapist") }
  scope :donors, -> { where(role_type: "Donor") }
  scope :admins, -> { where(role_type: "Administrator") }

  after_create :send_registered_email

  private
  def send_registered_email
    RegistrationMailer.registration_email(self).deliver_now
  end

end
