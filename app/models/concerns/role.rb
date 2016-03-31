module Role
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :role, dependent: :destroy

    delegate :name, to: :user
  end
end
