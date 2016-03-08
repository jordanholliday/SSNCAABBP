class ChangePicksTable < ActiveRecord::Migration
  def change
    remove_column :picks, :game_id
    remove_column :picks, :home
    add_column :picks, :team_id, :integer, null:false
    add_column :picks, :points, :integer, null:false
  end
end
