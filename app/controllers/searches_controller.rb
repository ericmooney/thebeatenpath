class SearchesController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
    @favorite = Favorite.find(params[:id])
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
    @route_pts = JSON.parse(params[:route_pts]) # in searches.js we've added a 5 sec delay; thus if you press the search button too soon it will return 'nil'

    client = Yelp::Client.new

    @route_pts.each do |yelp_request|
      latitude = yelp_request.first
      longitude = yelp_request.last

      request = Yelp::V2::Search::Request::GeoPoint.new(
                  :term => @search.name,
                  :latitude => latitude,
                  :longitude => longitude,
                  :radius=> 1,
                  :consumer_key => "<%= ENV['CONSUMER_KEY'] %>",
                  :consumer_secret => "<%= ENV['CONSUMER_SECRET'] %>",
                  :token => "<%= ENV['TOKEN'] %>",
                  :token_secret => "<%= ENV['TOKEN_SECRET'] %>")

      response = client.search(request)

      two_businesses = response["businesses"].take(2)

      names = two_businesses.map  do |business|
          business["name"]
      end

      # addresses = two_businesses.map do |business|
      #     Geocoder.search("#{latitude}, #{longitude}")
      # end


      addresses = two_businesses.map do |business|
          business["location"]["display_address"].join(' , ')
      end



      addresses.each_with_index do |address, i|
        Search.create(name:@search.name, yelp_query:names[i], favorite_id:@favorite.id, latitude:latitude, longitude:longitude, address:addresses[i])
      end




    end

    # request = Yelp::V1::Review::Request::Location.new(
    #              :address => @favorite["from"],
    #              :radius => 0.1,
    #              :term => @search.name,
    #              :yws_id => '5iVHiSXheAs_WzdKzcYE7g')

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
      redirect_to yelp_search_index_path(@search.favorite.id)
    else
      render action: "new"
    end
  end
end

