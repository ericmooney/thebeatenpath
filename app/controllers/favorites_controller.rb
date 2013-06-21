class FavoritesController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index # figure out later, probably apart of user experience/top 10
    @favorites = Favorite.all
  end

  def show # shows gmaps results
    @favorite = Favorite.find(params[:id])
  end

  def save
    @favorite = Favorite.find(params[:id])

    if !session[:user_id].blank?  #if the session has started i.e. the customer is logged in
      @user = User.find(session[:user_id])  #grab the user object
      @user.favorites << @favorite  #update the bridge table to associate the user and favorite
      @favorite.update_attributes(:is_saved => true) # marks the favorite as having been saved (may be redundant)
      redirect_to root_path
    else
      @user = User.new
      @favorite = Favorite.find(params[:id]) #if not logged in, grab the favorite object to be used after the login..
      render new_session_path
    end
  end

  def new # searches gmaps for directions, submit goes to create/also homepage ****
    @favorite = Favorite.new
  end

  def edit # edit field allows one to redo search with pre-pop params
    @favorite = Favorite.find(params[:id])
  end

  def create # saves and creates search from gmaps and then shows
    @favorite = Favorite.new(params[:favorite])

    if @favorite.save
      redirect_to yelp_search_path(@favorite.id)
    else
      render action: "new"
    end
  end

  def update # from edit page (with pre-pop params) updates favorites renders at show page
    @favorite = Favorite.find(params[:id])

    if @favorite.update_attributes(params[:favorite])
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy # deletes favorite/search and returns to favorites new/search page/homepage
    @favorite = Favorite.find(params[:id])
    if @favorite.destroy
      redirect_to root_path
    else
      render action: "show"
    end
  end

end
