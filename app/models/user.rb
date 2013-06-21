class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :favorites

  attr_accessible :email, :password, :password_confirmation, :favorite_id

  validates :email, :uniqueness => true
end
