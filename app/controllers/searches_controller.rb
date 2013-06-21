class SearchesController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
    @searches = Search.all
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
        "address: #{business["address1"]} #{business["address2"]} #{business["state"]} #{business["zip"]}"
      end
    end

    top_names = names.take(4)
    top_addresses = addresses.take(4)

    if @search.save
      @search.update_attributes(:favorite_id => @favorite.id)
      #yelp comes from params -- 'pizza'
      # need to update table columns: 'name' and 'address' from yelp query
      #@search.update_attribtutes(:address)

      redirect_to favorite_path(@favorite.id)
    else
      render action: "new"
    end
  end

  def update
    @search = Search.find(params[:id])

    if @search.update_attributes(params[:search])
      redirect_to @search
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

