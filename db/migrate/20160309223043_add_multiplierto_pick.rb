class AddMultipliertoPick < ActiveRecord::Migration
  def change
    add_column :picks, :multiplier, :integer
  end
end
