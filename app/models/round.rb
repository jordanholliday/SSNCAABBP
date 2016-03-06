class Round < ActiveRecord::Base
  validates :name, :picks_start, :picks_end, presence: true

  has_many :games
end
