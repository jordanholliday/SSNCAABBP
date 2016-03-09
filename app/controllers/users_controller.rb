class UsersController < ApplicationController
  before_action :redirect_unless_logged_out, only: [:new, :create]
  before_action :redirect_if_logged_out, only: [:show, :index]

  def index
    @users = User.all.sort
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to users_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:email, :team_name, :password, :name)
  end
end
