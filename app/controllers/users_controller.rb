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
    past_rounds = Round.where("picks_end < ?", DateTime.now )
                        .pluck(:id)
                        .join(",")
    # @user_picks = [1]
    @user_picks = ActiveRecord::Base.connection.select_all(<<-SQL
      SELECT
        rounds.id,
        rounds.name AS round_name,
        teams.name,
        teams.seed,
        picks.points,
        picks.multiplier,
        (picks.points *
          (CASE teams.seed WHEN 1 THEN 1.5 ELSE teams.seed END) *
          (CASE team_round_results.win WHEN true THEN 1 ELSE 0 END) *
          picks.multiplier) as payout,
        team_round_results.win AS result
      FROM
        users
      LEFT JOIN
        picks ON picks.user_id = users.id
      JOIN
        teams ON teams.id = picks.team_id
      LEFT JOIN
        team_round_results ON (
        team_round_results.round_id = picks.round_id AND
        team_round_results.team_id = picks.team_id
        )
      JOIN
        rounds ON rounds.id = picks.round_id
      WHERE
        users.id  = #{@user.id} AND
        picks.round_id IN (#{past_rounds})
      SQL
      ).sort_by {|pick| pick["id"].to_i}
  end

  def scoreboard
    @scoreboard = scores_by_user_by_round
    @rounds = Round.all.sort
  end

  private
  def user_params
    params.require(:user).permit(:email, :team_name, :password, :name)
  end

  def scores_by_user_by_round
    ActiveRecord::Base.connection.select_all(<<-SQL
      SELECT
        users.id,
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
        users.id, users.team_name, users.name, picks.round_id
      SQL
      )
  end
end
