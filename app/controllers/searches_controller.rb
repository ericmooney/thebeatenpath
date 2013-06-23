class SearchesController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
    @favorite = Favorite.find(params[:id])
    if
      favorite_path(@favorite.id)
    else
      render action: "new"
    end
  end

  def show
    @search = Search.find(params[:id])
  end

  def new
    @search = Search.new
    @favorite = Favorite.find(params[:id])
  end

  def edit
    @search = Search.find(params[:id])
  end

  def create
    @search = Search.new(params[:search])
    @favorite = Favorite.find(params[:favorite_id])

    #construct a client instance
    client = Yelp::Client.new

    # perform an address/location-based search from the params
    request = Yelp::V1::Review::Request::Location.new(
                 :address => @favorite["from"],
                 :radius => 0.1,
                 :term => @search.yelp_query,
                 :yws_id => '5iVHiSXheAs_WzdKzcYE7g')

    response = client.search(request)

    four_businesses = response["businesses"].take(4)

    names = four_businesses.map  do |business|
        business["name"]
    end

    addresses = four_businesses.map do |business|
        "#{business["address1"]} #{business["address2"]} #{business["state"]} #{business["zip"]}"
    end

    addresses.each_with_index do |address, i|
      Search.create(address:address, yelp_query:names[i], favorite_id:@favorite.id)
    end

    redirect_to favorite_path(@favorite.id)
  end

  def update
    @search = Search.find(params[:id])
    if @search.update_attributes(params[:search])
      redirect_to yelp_search_index_path(@search.favorite.id)
    else
      render action: "new"
    end
  end

  def destroy
    @search = Search.find(params[:id])

    if @search.destroy
      redirect_to root_path
    else
      render action: "new"
    end
  end
end

