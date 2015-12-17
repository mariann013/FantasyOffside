class RemoveCreatedAndUpdatedAtFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :created_at, :timestamp
    remove_column :players, :updated_at, :timestamp
  end
end
