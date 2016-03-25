module Role
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :role

    delegate :name, to: :user
  end
end
