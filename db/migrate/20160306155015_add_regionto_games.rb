class AddRegiontoGames < ActiveRecord::Migration
  def change
    add_column :games, :region, :string
  end
end
