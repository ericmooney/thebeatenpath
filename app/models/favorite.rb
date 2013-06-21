class Favorite < ActiveRecord::Base
  has_and_belongs_to_many :users

  attr_accessible :name, :from, :to, :is_saved, :user_id
end
