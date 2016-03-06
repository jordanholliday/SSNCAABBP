class TeamsController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @teams = Team.all.sort_by {|team| team.seed }
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_url
    else
      flash.now[:errors] = @team.error.full_messages
      render :index
    end
  end

  def destroy
    team = team.find(params[:id])
    team.destroy
    redirect_to teams_url
  end


  private
  def team_params
    params.require(:team).permit(:name, :seed)
  end
end
