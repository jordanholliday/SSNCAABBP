class Round < ActiveRecord::Base
  validates :name, :picks_start, :picks_end, presence: true

  has_many :games
  has_many :picks, through: :games
  has_many :home_teams, through: :games
  has_many :away_teams, through: :games
end
