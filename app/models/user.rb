class User < ApplicationRecord
  devise :database_authenticatable, :invitable, :recoverable, :rememberable, :validatable

end
