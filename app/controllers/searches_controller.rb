class SearchesController < ApplicationController

  skip_before_filter :require_authentication

  def index
    @favorites = Favorite.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
