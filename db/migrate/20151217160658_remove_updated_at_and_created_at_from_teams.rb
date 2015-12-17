class RemoveUpdatedAtAndCreatedAtFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :updated_at, :timestamp
    remove_column :teams, :created_at, :timestamp
  end
end
