class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :name, null:false
      t.datetime :picks_start, null:false
      t.datetime :picks_end, null:false
      t.timestamps null: false
    end
  end
end
