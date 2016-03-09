class PicksController < ApplicationController
  before_action :redirect_if_logged_out
  before_action :redirect_to_new_picks, only: [:index]

  def index

  end

  def new
    @current_rounds = Round.where("picks_start < ?", DateTime.now)
                           .where("picks_end > ?", DateTime.now)

    no_loss_teams_query = <<-SQL
      id NOT IN (
        SELECT
          team_id
        FROM
          team_round_results
        WHERE
          win = false
          )
    SQL

    @teams = Team.where(no_loss_teams_query).sort_by { |team| team.name }

    @picks = current_user.picks.includes(:team)
  end

  def create
    pick = Pick.new(pick_params)
    pick.user_id = current_user.id

    if pick.save
      redirect_to new_pick_url
    else
      flash[:errors] = pick.errors.full_messages
      redirect_to new_pick_url
    end
  end

  def destroy
    pick = Pick.find(params[:id])
    pick.destroy if pick.round.picks_open?
    redirect_to new_pick_url
  end

  private
  def pick_params
    params.require(:pick).permit(:team_id, :round_id, :points, :multiplier)
  end

  def redirect_to_new_picks
    redirect_to new_pick_url
  end
end
