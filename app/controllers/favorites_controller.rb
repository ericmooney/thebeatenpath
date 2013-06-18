class FavoritesController < ApplicationController

  skip_before_filter :require_authentication, :only => [:show]
  skip_before_filter :require_admin_authentication

  def index
    @favorites = Favorite.all
  end

  def show
    @favorite = Favorite.find(params[:id])
  end

  def new
    @favorite = Favorite.new
  end

  def edit
    @favorite = Favorite.find(params[:id])
  end

  def create
    @favorite = Favorite.new(params[:favorite])

    if @favorite.save
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @favorite = Favorite.find(params[:id])

    if @favorite.update_attributes(params[:favorite])
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
  end

end
