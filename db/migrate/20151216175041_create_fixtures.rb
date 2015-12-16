class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.integer :game_week
      t.integer :opponent_id
      t.boolean :is_home

      t.timestamps null: false
    end
  end
end
