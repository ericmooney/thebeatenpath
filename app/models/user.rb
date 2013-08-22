class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :favorites

  attr_accessible :email, :password, :password_confirmation, :favorite_id

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_presence_of :email
  validates_uniqueness_of :email
end
