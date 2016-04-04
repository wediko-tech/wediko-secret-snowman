class Event < ActiveRecord::Base
  has_many :lists

  validates :title, presence: true

  alias_attribute :name, :title
end
