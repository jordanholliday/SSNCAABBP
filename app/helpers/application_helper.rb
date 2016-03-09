module ApplicationHelper

  def auth_token
    <<-HTML.html_safe
      <input type="hidden" name="authenticity_token" value="#{ form_authenticity_token }">
    HTML
  end

  def my_delete_button(url)
    <<-HTML.html_safe
      <form action="#{ url }" method="POST">
        <input type="hidden" name="_method" value="DELETE">
        #{ auth_token }
        <input type="submit" value="DELETE">
      </form>
    HTML
  end

  def team_round_result_win_button(team_id, round_id)
    button_to "Record Win",
    team_round_results_url,
    params: { method: :post, win: true, team_id: team_id, round_id: round_id }
  end

  def team_round_result_loss_button(team_id, round_id)
    button_to "Record Loss",
    team_round_results_url,
    params: { method: :post, win: false, team_id: team_id, round_id: round_id }
  end

  def remove_team_round_result_button(team_round_result, team_id, round_id)
    button_to "(undo?)",
    team_round_result_url(team_round_result),
    method: :delete
  end

  def already_won?(team, round)
    team.team_round_results.select {
      |result| result.round_id == round.id && result.win}.any?
  end

  def already_lost?(team, round)
    team.team_round_results.select {
      |result| result.round_id == round.id && result.win == false}.any?
  end


end
