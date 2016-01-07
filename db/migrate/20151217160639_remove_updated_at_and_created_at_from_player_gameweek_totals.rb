class RemoveUpdatedAtAndCreatedAtFromPlayerGameweekTotals < ActiveRecord::Migration
  def change
    remove_column :player_gameweek_totals, :updated_at, :timestamp
    remove_column :player_gameweek_totals, :created_at, :timestamp
  end
end
