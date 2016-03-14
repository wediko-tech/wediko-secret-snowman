class User < ActiveRecord::Base
  belongs_to :role, polymorphic: true
end
