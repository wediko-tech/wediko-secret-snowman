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


  validate :validate_donor_fields

  def validate_donor_fields
    if role_type == 'Donor'
      unless Phonelib.valid_for_country?(phone_number, 'US') || Phonelib.possible?(phone_number)
        errors.add(:phone_number, 'must be valid')
      end

      mandatory_address_fields = %w(address_line_1 address_city address_zip_code)

      mandatory_address_fields.each do |field|
        if self.send(field).blank?
          errors.add(field, "can't be blank")
        end
      end

    end
  end
end
