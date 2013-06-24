# This is for our yelp queries

class Search < ActiveRecord::Base
  attr_accessible :address, :favorite_id, :name, :yelp_query, :latitude, :longitude

  belongs_to :favorite



end
