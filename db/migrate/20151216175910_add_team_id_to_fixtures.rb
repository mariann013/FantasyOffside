class AddTeamIdToFixtures < ActiveRecord::Migration
  def change
    add_reference :fixtures, :team, index: true, foreign_key: true
  end
end
