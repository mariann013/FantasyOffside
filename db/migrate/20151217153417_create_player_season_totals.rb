class CreatePlayerSeasonTotals < ActiveRecord::Migration
  def change
    create_table :player_season_totals do |t|
      t.integer :goals_scored
      t.integer :goals_assisted
      t.integer :clean_sheets
      t.integer :goals_conceded
      t.integer :own_goals
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :minutes_played

      t.timestamps null: false
    end
  end
end
