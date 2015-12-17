class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :playerdata
      t.integer :teamid
      t.string :position
      t.float :price

      t.timestamps null: false
    end
  end
end
