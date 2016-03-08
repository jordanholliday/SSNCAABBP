class AddRoundtoPicks < ActiveRecord::Migration
  def change
    add_column :picks, :round_id, :integer, null:false
  end
end
