class User < ActiveRecord::Base
  include HasRole
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role, polymorphic: true, dependent: :destroy

  # see concerns/has_role.rb for more detail
  role_predicates "administrator", "therapist", "donor"

  scope :therapists, -> { where(role_type: "Therapist") }
  scope :donors, -> { where(role_type: "Donor") }
  scope :admins, -> { where(role_type: "Administrator") }

  def therapist?
    self.role_type == "Therapist"
  end

  def donor?
    self.role_type == "Donor"
  end
end
