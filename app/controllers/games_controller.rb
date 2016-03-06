class GamesController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @rounds = Round.all.includes(:games)
    @game = Game.new
    @teams = Team.all.sort_by { |team| team.name }
  end

  def create
    game = Game.new(game_params)

    if game.save
      redirect_to games_url
    else
      flash[:errors] = game.errors.full_messages
      redirect_to games_url
    end
  end

  private
  def game_params
    params.require(:game).permit(:home_team_id, :away_team_id, :region, :round_id)
  end
end
