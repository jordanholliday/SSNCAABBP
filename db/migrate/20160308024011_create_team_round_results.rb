class CreateTeamRoundResults < ActiveRecord::Migration
  def change
    create_table :team_round_results do |t|
      t.integer :team_id, null: false
      t.integer :round_id, null: false
      t.boolean :win, null: false
      t.timestamps null: false
    end

    add_index :team_round_results, [:team_id, :round_id], unique: true
  end
end
