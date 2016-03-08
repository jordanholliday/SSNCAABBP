class TeamRoundResult < ActiveRecord::Base
  validates :team_id, :round_id, presence: true
  validates :win, inclusion: { in: [true, false] }

  belongs_to :team
  belongs_to :round
end
