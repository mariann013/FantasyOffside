class RemoveUpdatedAtAndCreatedAtFromFixtures < ActiveRecord::Migration
  def change
    remove_column :fixtures, :updated_at, :timestamp
    remove_column :fixtures, :created_at, :timestamp
  end
end
