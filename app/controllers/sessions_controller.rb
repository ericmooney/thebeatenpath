class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if !params[:favorite_id].nil?
        @favorite = Favorite.find(params[:favorite_id]) #if a favorite param comes in (i.e. page was rendered from a non-logged-in user that wanted to sign up)
        user.favorites << @favorite #push favorite into bridge table
      end
      redirect_to new_favorite_path, :notice => "Nice! You logged in."
    else
      flash.now[:alert] = "Your email or password are not correct."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Okay, you're logged out."
  end
end
