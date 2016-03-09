class Round < ActiveRecord::Base
  validates :name, :picks_start, :picks_end, presence: true

  has_many :games
  has_many :picks, through: :games
  has_many :team_round_results

  def self.reverse_chron
    Round.all.sort_by { |round| round.id * -1}
  end

  def <=>(round)
    self.id <=> round.id
  end

  def teams_in_round
    Team.where(
      "
        id NOT IN (
      SELECT
        team_id
      FROM
        team_round_results
      WHERE
        win = false AND
        round_id < #{id}
      )
      "
    )
  end

  def picks_open?
    now = DateTime.now
    now >= picks_start && now <= picks_end
  end

end
