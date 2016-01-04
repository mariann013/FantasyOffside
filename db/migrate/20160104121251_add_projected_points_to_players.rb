class AddProjectedPointsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :projected_points, :integer
  end
end
