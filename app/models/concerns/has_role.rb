module HasRole
  extend ActiveSupport::Concern

  class_methods do
    # defines predicates to see if a user is a particular role, e.g. therapist?
    def role_predicates(*roles)
      roles.each do |role|
        define_method("#{role}?") do
          self.role_id.present? && self.role_type == role.capitalize
        end
      end
    end
  end
end
