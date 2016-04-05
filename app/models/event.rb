class Event < ActiveRecord::Base
  has_many :lists, dependent: :destroy

  validates :title, presence: true

  alias_attribute :name, :title
end
