class Pick < ActiveRecord::Base
  after_initialize :ensure_multiplier

  validates :user_id, :round_id, :team_id, :points, presence: true
  validates :points, numericality: {only_integer: true}
  validates :multiplier, inclusion: { in: [1, 2] }
  validate :bet_limit_half_total_points_per_round, :one_double_per_round, :one_bet_per_team_per_round

  belongs_to :user
  belongs_to :round
  belongs_to :team

  def self.user_picks_per_round(user, round)
    Pick.where(user_id: user.id).where(round_id: round.id).includes(:team)
  end

  def result
    TeamRoundResult.where(
      "round_id = ? AND team_id = ?",
      self.round_id,
      self.team_id
      )
  end

  private
  def bet_limit_half_total_points_per_round
    return unless points.is_a?(Integer)
    total_points_wagered_round = user.picks.where(round_id: round_id).sum(:points)
    limit = (user.score / 2)
    if total_points_wagered_round + points > limit
      errors[:pick] << ": You can only wager #{limit - total_points_wagered_round} more points in the #{round.name}"
    end
  end

  def pick_round_is_open
    unless pick.round.picks_open?
      errors[:pick] << ": No more picks for that round!"
    end
  end

  def one_double_per_round
    return if self.multiplier == 1
    if Pick.where(
        user_id: self.user_id,
        round_id: self.round_id,
        multiplier: 2).any?
      errors[:pick] << ": Only one double per round!"
    end
  end

  def one_bet_per_team_per_round
    if Pick.where(
        user_id: self.user_id,
        round_id: self.round_id,
        team_id: self.team_id).any?
      errors[:pick] << ": Already picked that team!"
    end
  end

  def ensure_multiplier
    self.multiplier ||= 1
  end

end
