class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_team_id, null: false
      t.integer :away_team_id, null: false
      t.integer :round_id, null:false
      t.timestamps null: false
    end

    add_index :games, :home_team_id
    add_index :games, :away_team_id
    add_index :games, :round_id
  end
end
