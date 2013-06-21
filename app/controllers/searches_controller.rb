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

