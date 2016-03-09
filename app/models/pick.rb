class Pick < ActiveRecord::Base
  validates :user_id, :round_id, :team_id, :points, presence: true
  validates :points, numericality: {only_integer: true}
  validate :bet_limit_half_total_points_per_round

  belongs_to :user
  belongs_to :round
  belongs_to :team

  def self.user_picks_per_round(user, round)
    Pick.where(user_id: user.id).where(round_id: round.id).includes(:team)
  end

  private
  def bet_limit_half_total_points_per_round
    return unless points.is_a?(Integer)
    total_points_wagered_round = user.picks.where(round_id: round_id).sum(:points)
    limit = (user.score / 2)
    if total_points_wagered_round + points > limit
      errors[:points] << ": You can only wager #{limit - total_points_wagered_round} more points in the #{round.name}"
    end
  end
end
