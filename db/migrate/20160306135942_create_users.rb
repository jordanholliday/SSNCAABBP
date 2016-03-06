class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :team_name
      t.string :password_digest
      t.string :session_token
      t.boolean :admin, default: false
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
