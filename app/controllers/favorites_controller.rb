class FavoritesController < ApplicationController
  # GET /favorites
  # GET /favorites.json
  def index
    @favorites = Favorite.all
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
    @favorite = Favorite.find(params[:id])
  end

  # GET /favorites/new
  # GET /favorites/new.json
  def new
    @favorite = Favorite.new

  end

  # GET /favorites/1/edit
  def edit
    @favorite = Favorite.find(params[:id])
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(params[:favorite])

    if @favorite.save
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /favorites/1
  # PUT /favorites/1.json
  def update
    @favorite = Favorite.find(params[:id])

    if @favorite.update_attributes(params[:favorite])
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render action: "new"
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
  end

end
