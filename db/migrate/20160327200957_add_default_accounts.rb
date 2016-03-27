class AddDefaultAccounts < ActiveRecord::Migration
  TEMP_PASSWORD = "TEMPORARYWED"
  def up
    [Administrator.create!, Therapist.create!, Donor.create!].each do |role|
      email = "#{role.class.to_s.downcase}@wediko.org"
      unless User.find_by(email: email)
        User.create(email: email, password: TEMP_PASSWORD, password_confirmation: TEMP_PASSWORD,
          role: role)
      end
    end
  end

  def down
    ["administrator", "therapist", "donor"].each do |role|
      User.find_by(email: "#{role}@wediko.org").try(:destroy)
    end
  end
end
