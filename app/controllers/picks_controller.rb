class PicksController < ApplicationController
  def new
    @current_rounds = Round.where("picks_start < ?", DateTime.now)
                           .where("picks_end > ?", DateTime.now)
                           .includes(:games => [:home_team, :away_team])

    @teams = @current_rounds
              .map { |round| round.home_teams + round.away_teams }
              .flatten
              .uniq
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

  private
  def pick_params
    params.require(:pick).permit(:team_id, :round_id, :points)
  end
end
