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
  end

  def edit
    @search = Search.find(params[:id])
  end

  def create
    @search = Search.new(params[:search])

    if @search.save
      redirect_to @search
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

