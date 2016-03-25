class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password].strip
      )

    if @user
      login!(@user)
      redirect_to scoreboard_users_url
    else
      flash.now[:errors] = ["invalid email / password combo"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to root_url
  end
end
