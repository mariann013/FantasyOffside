class RemoveUpdatedAtFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :updated_at, :timestamp
  end
end
