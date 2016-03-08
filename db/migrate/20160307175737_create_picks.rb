class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :user_id, null: false
      t.integer :game_id, null: false
      t.boolean :home, null: false
      t.timestamps null: false
    end

    add_index :picks, :user_id
    add_index :picks, :game_id
  end
end
