class Team < ActiveRecord::Base
  validates :name, :seed, presence: true
  validates :seed, :inclusion => { :in => 1..16 }


end
