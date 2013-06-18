class SessionsController < ApplicationController

  #for now, we will have a blanket "skip" so login not required on these pages
  #we will need to revisit this later, though!
  skip_before_filter :require_authentication

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to new_favorite_path, :notice => "Nice! You logged in."
      # the flash notices are not set up in the view yet.
    else
      flash.now[:alert] = "Your email or password are not correct."
      # the flash notices are not set up in the view yet.
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Okay, you're logged out."
  end
end
