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

    @favorite = Favorite.find(params[:favorite_id])

    #construct a client instance
    client = Yelp::Client.new

    # perform an address/location-based search from the params
    request = Yelp::V1::Review::Request::Location.new(
                 :address => @favorite["from"],
                 :radius => 2,
                 :term => @search,
                 :yws_id => '5iVHiSXheAs_WzdKzcYE7g')

    response = client.search(request)

    # 4 names with avg score >= 3.5
    names = response["businesses"].map  do |business|
      if business["avg_rating"] >= 3.5 && business["name"] != nil
        business["name"]
      end
    end

    # addresses of names
    addresses = response["businesses"].map do |business|
      if business["avg_rating"] >= 3.5 && business["name"] != nil
        "#{business["address1"]}, #{business["address2"]}, #{business["state"]}, #{business["zip"]}"
      end
    end

    top_names = names.take(4)
    top_addresses = addresses.take(4)

    # this creates an object of our searches by looping through the addresses we pass in
    top_addresses.each_with_index do |address, i|
      Search.create(address:address, yelp_query:top_names[i], favorite_id:@favorite.id)
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

