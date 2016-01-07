class CreatePlayerGameweekTotals < ActiveRecord::Migration
  def change
    create_table :player_gameweek_totals do |t|
      t.integer :playerid
      t.integer :gameweek
      t.integer :minutes_played
      t.integer :goals_scored
      t.integer :assists
      t.integer :clean_sheets
      t.integer :goals_conceded
      t.integer :own_goals
      t.integer :penalties_saved
      t.integer :penalties_missed
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :saves
      t.integer :bonus_points
      t.integer :total_points


      t.timestamps null: false
    end
  end
end
