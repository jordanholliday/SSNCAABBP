class PicksController < ApplicationController
  before_action :redirect_if_logged_out, :redirect_if_picks_closed
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

    @current_and_past_rounds = Round.where("picks_start < ?", DateTime.now)

    if flash[:round]
      @last_pick_round_id = flash[:round].to_i
    else
      @last_pick_round_id = -1
    end
  end

  def create
    pick = Pick.new(pick_params)
    pick.user_id = current_user.id

    if pick.save
      flash[:round] = params[:pick][:round_id]
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
