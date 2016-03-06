class Game < ActiveRecord::Base
  validates :home_team_id, :away_team_id, :round_id, presence: true

  belongs_to :round

  belongs_to(
    :home_team,
    class_name: 'Team',
    foreign_key: :home_team_id
    )

  belongs_to(
    :away_team,
    class_name: 'Team',
    foreign_key: :away_team_id
    )


  def self.regions
    %w(East South Midwest West) + [""]
  end
end
