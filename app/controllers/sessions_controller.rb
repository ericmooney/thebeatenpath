class SessionsController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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
