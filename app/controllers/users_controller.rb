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

  def scoreboard
    @scoreboard = scores_by_user_by_round
  end

  private
  def user_params
    params.require(:user).permit(:email, :team_name, :password, :name)
  end

  def scores_by_user_by_round
    ActiveRecord::Base.connection.select_all( <<-SQL
      SELECT
        users.team_name,
        users.name,
        picks.round_id,
        SUM(picks.points *
        picks.multiplier *
        teams.seed *
        (
        CASE WHEN
            team_round_results.win = true
        THEN
            1
        ELSE
            0
        END)
        ) AS points
      FROM
        team_round_results
      JOIN
        picks ON
          picks.team_id = team_round_results.team_id AND
          picks.round_id = team_round_results.round_id
      JOIN
        teams ON
          teams.id = team_round_results.team_id
      JOIN
        users ON users.id = picks.user_id
      GROUP BY
        users.team_name, users.name, picks.round_id
      SQL
      )
  end
end
