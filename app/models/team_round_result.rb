class TeamRoundResult < ActiveRecord::Base
  validates :team_id, :round_id, presence: true
  validates :win, inclusion: { in: [true, false] }
  validates :team_id, uniqueness: {scope: :round_id}

  belongs_to :team
  belongs_to :round
end
