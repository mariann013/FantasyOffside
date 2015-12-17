class CreatePlayerSeasonTotals < ActiveRecord::Migration
  def change
    create_table :player_season_totals do |t|
      t.integer :goals_scored
      t.integer :goals_assisted
      t.integer :cleansheets
      t.integer :goals_conceded
      t.integer :owngoals
      t.integer :yellowcards
      t.integer :redcards
      t.integer :minutesplayed

      t.timestamps null: false
    end
  end
end
