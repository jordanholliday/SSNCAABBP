class Team < ActiveRecord::Base
  validates :name, :seed, presence: true
  validates :seed, :inclusion => { :in => 1..16 }

  has_many :team_round_results

  def <=>(team)
    self.seed <=> team.seed
  end

end
