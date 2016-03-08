class Pick < ActiveRecord::Base
  validates :user_id, :round_id, :team_id, :points, presence: true
  validate :bet_limit_half_total_points_per_round

  belongs_to :user
  belongs_to :round
  belongs_to :team

  # private
  def bet_limit_half_total_points_per_round
    total_points_wagered_round = user.picks.where(round_id: round_id).sum(:points)
    limit = (user.score / 2)
    if total_points_wagered_round + points > limit
      errors[:points] << ":you can only wager #{limit - total_points_wagered_round} more points in the #{round.name}"
    end
  end
end
