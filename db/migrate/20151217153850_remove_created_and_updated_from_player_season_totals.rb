class RemoveCreatedAndUpdatedFromPlayerSeasonTotals < ActiveRecord::Migration
  def change
    remove_column :player_season_totals, :created_at, :timestamp
    remove_column :player_season_totals, :updated_at, :timestamp
  end
end
