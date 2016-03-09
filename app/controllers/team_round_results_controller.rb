class TeamRoundResultsController < ApplicationController
  def create
    trr = TeamRoundResult.new(team_round_result_params)

    if trr.save
      redirect_to rounds_url
    else
      flash[:errors] = trr.errors.full_messages
      redirect_to rounds_url
    end
  end

  def destroy
    trr = TeamRoundResult.find(params[:id])
    trr.destroy
    redirect_to rounds_url
  end


  private
  def team_round_result_params
    params.permit(:team_id, :round_id, :win)
  end
end
