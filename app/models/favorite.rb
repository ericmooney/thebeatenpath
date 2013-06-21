class Favorite < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :searches

  attr_accessible :name, :from, :to, :is_saved
end
