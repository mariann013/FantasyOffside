class RemoveCreatedAtFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :created_at, :timestamp
  end
end
