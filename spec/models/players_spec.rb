require 'spec_helper'

require 'database_cleaner'

DatabaseCleaner.strategy = :truncation


describe Player, type: :model do
  it 'is expected to output 4 points for projected points' do
    DatabaseCleaner.clean
    player = Player.create(playerdata: "test_player", teamid: 1, position: "Goalkeeper", price: 5.5)
    i = 1
    while i <= 650
      Player.create(playerdata: "test")
      PlayerGameweekTotal.create(playerid: i, gameweek: '5', total_points: '4')
      i += 1
    end
    Team.create(name: "test_team")
    PlayerGameweekTotal.create(playerid: "1", gameweek: '5', total_points: '4')
    PlayerGameweekTotal.create(playerid: "1", gameweek: '4', total_points: '5')
    PlayerGameweekTotal.create(playerid: "1", gameweek: '3', total_points: '3')
    PlayerGameweekTotal.create(playerid: "1", gameweek: '2', total_points: '4')
    PlayerGameweekTotal.create(playerid: '1', gameweek: '1', total_points: '4')
    Player.update_gk
    player = Player.find(1)
    expect(player.projected_points).to eq(4)
  end
end
