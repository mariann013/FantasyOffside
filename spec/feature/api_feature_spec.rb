require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe 'API' do

  let(:browser) { double(:browser, goto: true, close: true) }
  let(:row) { double(:row) }

  before :each do
    DatabaseCleaner.clean
  end

  describe 'first test' do

    it 'scrapes the user\'s squad and returns it in json', type: :request do

      Player.create(playerdata: "player01", teamid: 1, position: "gk", price: 0.5)
      Player.create(playerdata: "player02", teamid: 2, position: "gk", price: 1)
      Player.create(playerdata: "player03", teamid: 3, position: "def", price: 1.5)
      Player.create(playerdata: "player04", teamid: 4, position: "def", price: 2)
      Player.create(playerdata: "player05", teamid: 5, position: "def", price: 2.5)
      Player.create(playerdata: "player06", teamid: 1, position: "def", price: 3)
      Player.create(playerdata: "player07", teamid: 2, position: "def", price: 3.5)
      Player.create(playerdata: "player08", teamid: 3, position: "mid", price: 4)
      Player.create(playerdata: "player09", teamid: 4, position: "mid", price: 4.5)
      Player.create(playerdata: "player10", teamid: 5, position: "mid", price: 5)
      Player.create(playerdata: "player11", teamid: 1, position: "mid", price: 5.5)
      Player.create(playerdata: "player12", teamid: 2, position: "mid", price: 6)
      Player.create(playerdata: "player13", teamid: 3, position: "att", price: 6.5)
      Player.create(playerdata: "player14", teamid: 4, position: "att", price: 7)
      Player.create(playerdata: "player15", teamid: 5, position: "att", price: 7.5)
      Team.create(name: "team01")
      Team.create(name: "team02")
      Team.create(name: "team03")
      Team.create(name: "team04")
      Team.create(name: "team05")

      expected_parsed_body = {
        squad: {
          gk: {id: 1, playerdata: "player01", image: "shirt_1_1.png", teamname: "team01", teamid: 1, position: "gk", price: 0.5, projected_points: 1},
          defenders: [
            {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "def", price: 1.5, projected_points: 1},
            {id: 4, playerdata: "player04", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "def", price: 2, projected_points: 1},
            {id: 6, playerdata: "player06", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "def", price: 3, projected_points: 1},
            {id: 7, playerdata: "player07", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "def", price: 3.5, projected_points: 1}
          ],
          midfielders: [
            {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "mid", price: 4, projected_points: 3},
            {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "mid", price: 5, projected_points: 2},
            {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "mid", price: 5.5, projected_points: 1},
            {id: 12, playerdata: "player12", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "mid", price: 6, projected_points: 1}
          ],
          attackers: [
            {id: 13, playerdata: "player13", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "att", price: 6.5, projected_points: 1},
            {id: 15, playerdata: "player15", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "att", price: 7.5, projected_points: 1}
          ],
          substitutes: [
            {id: 2, playerdata: "player02", image: "shirt_2_1.png", teamname: "team02", teamid: 2, position: "gk", price: 1, projected_points: 1},
            {id: 5, playerdata: "player05", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "def", price: 2.5, projected_points: 1},
            {id: 9, playerdata: "player09", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "mid", price: 4.5, projected_points: 1},
            {id: 14, playerdata: "player14", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "att", price: 7, projected_points: 1}
          ]
        },
        playerids: [1,3,4,6,7,8,10,11,12,13,15,2,5,9,14],
        formation: [1,4,4,2],
        captain: {id: 8, playerdata: "player08", teamid: 3, position: "mid", price: 4, projected_points: 3},
        vicecaptain: {id: 10, playerdata: "player10", teamid: 5, position: "mid", price: 5, projected_points: 2},
        cash: 5.2
      }

      allow(Watir::Browser).to receive(:new).and_return(browser)
      rows = [""]
      15.times { rows.push(row) }
      allow(browser).to receive_message_chain("table.rows") { rows }
      allow(row).to receive_message_chain(:cells, :[], :link, :href)
        .and_return("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15")

      get getsquad_path(fplid: "000000")

      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq(expected_parsed_body)

    end

    it 'returns optimised squad json', type: :request do
      expected_optimised_parsed_body = {
        squad: {
          gk: {id: 1, playerdata: "player01", image: "shirt_1_1.png", teamname: "team01", teamid: 1, position: "gk", price: 0.5, projected_points: 1},
          defenders: [
            {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "def", price: 1.5, projected_points: 1},
            {id: 4, playerdata: "player04", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "def", price: 2, projected_points: 1},
            {id: 6, playerdata: "player06", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "def", price: 3, projected_points: 1},
            {id: 7, playerdata: "player07", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "def", price: 3.5, projected_points: 1}
          ],
          midfielders: [
            {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "mid", price: 4, projected_points: 3},
            {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "mid", price: 5, projected_points: 2},
            {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "mid", price: 5.5, projected_points: 1},
            {id: 12, playerdata: "player12", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "mid", price: 6, projected_points: 1}
          ],
          attackers: [
            {id: 13, playerdata: "player13", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "att", price: 6.5, projected_points: 1},
            {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "att", price: 8.5, projected_points: 2},
          ],
          substitutes: [
            {id: 2, playerdata: "player02", image: "shirt_2_1.png", teamname: "team02", teamid: 2, position: "gk", price: 1, projected_points: 1},
            {id: 5, playerdata: "player05", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "def", price: 2.5, projected_points: 1},
            {id: 9, playerdata: "player09", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "mid", price: 4.5, projected_points: 1},
            {id: 14, playerdata: "player14", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "att", price: 7, projected_points: 1}
          ]
        },
        transfers: {
          out: {id: 15, playerdata: "player15", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "att", price: 7.5, projected_points: 1},
          in: {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "att", price: 8.5, projected_points: 2}
        }
        formation: [1,4,4,2],
        captain: {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "mid", price: 4, projected_points: 3},
        vicecaptain: {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "mid", price: 5, projected_points: 2},
        cash: 4.2
      }

    end

    it 'returns transferred players', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 4)
        end
      end
      Player.create(playerdata: "player16", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 3)
      Player.create(playerdata: "player17", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 5)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      get optimiseSquad_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)

      expected_transfers = {
        out: {
          id: 1,
          name: "player",
          teamid: 1,
          price: 1.0
        },
        in: {
          id: 17,
          name: "player17",
          teamid: 14,
          price: 1.0
        }
      }
      expect(response.body).to include(expected_transfers.to_json)
    end

  end

  # describe 'squad scraping' do
    # it 'scrapes the user\'s squad and returns details', type: :request do
    #   Player.create(playerdata: "test_player", teamid: 1, position: "Goalkeeper", price: 5.5)
    #   Team.create(name: "test_team")
    #   allow(Watir::Browser).to receive(:new).and_return(browser)
    #   allow(browser).to receive_message_chain("table.rows") { ["", row] }
    #   allow(row).to receive_message_chain(:cells, :[], :link, :href) { "1" }
    #   get getsquad_path(fplid: '0000000')
    #   expect(response.status).to eq(200)
    #   expect(response.content_type).to eq(Mime::JSON)
    #   expect(response.body).to eq "[[\"test_player\",\"test_team\",\"Goalkeeper\",5.5]]"
    # end
  #
  #   it 'should throw an error if fplid is not a number', type: :request do
  #     get getsquad_path(fplid: 'abcdef')
  #     expect(response.status).to eq(400)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to eq "Invalid team id number"
  #   end
  #
  #   it 'should throw an error if a blank fplid is provided', type: :request do
  #     get getsquad_path(fplid: '')
  #     expect(response.status).to eq(400)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to eq "Invalid team id number"
  #   end
  #
  #   it 'should throw an error if no parameter is provided', type: :request do
  #     get getsquad_path()
  #     expect(response.status).to eq(400)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to eq "Invalid team id number"
  #   end
  # end
  #
  # describe 'getting transfers' do
  #   it 'should suggest transfer which excludes current squad', type: :request do
  #     (1..5).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
  #       end
  #     end
  #     Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     allow_any_instance_of(Array).to receive(:sample).and_return(1)
  #     get optimiseSquad_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player","in":"player16"}')
  #   end
  #
  #   it 'should suggest a transfer of correct position', type: :request do
  #     (1..5).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
  #       end
  #     end
  #     Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)
  #     Player.create(playerdata: "player17", teamid: 1, position: "Defender", price: 1)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     allow_any_instance_of(Array).to receive(:sample).and_return(1)
  #     get optimiseSquad_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player","in":"player16"}')
  #   end
  #
  #   it 'should suggest transfer that doesn\'t exceed cash constraint', type: :request do
  #     (1..5).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
  #       end
  #     end
  #     Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 11)
  #     Player.create(playerdata: "player17", teamid: 1, position: "Goalkeeper", price: 12)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     allow_any_instance_of(Array).to receive(:sample).and_return(1)
  #     get optimiseSquad_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player","in":"player16"}')
  #   end
  #
  #   it 'should suggest a transfer that doesn\'t exceed max players per team', type: :request do
  #     (1..5).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
  #       end
  #     end
  #     Player.create(playerdata: "player16", teamid: 2, position: "Goalkeeper", price: 1)
  #     Player.create(playerdata: "player17", teamid: 6, position: "Goalkeeper", price: 1)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     allow_any_instance_of(Array).to receive(:sample).and_return(1)
  #     get optimiseSquad_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player","in":"player17"}')
  #   end
  #
  #   it 'should suggest transfer which yields maximum projected points', type: :request do
  #     (1..5).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
  #       end
  #     end
  #     Player.create(playerdata: "player16", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
  #     Player.create(playerdata: "player17", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 6)
  #     Player.create(playerdata: "player18", teamid: 6, position: "Goalkeeper", price: 12, projected_points: 7)
  #     Player.create(playerdata: "player19", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 5)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     allow_any_instance_of(Array).to receive(:sample).and_return(1)
  #     get optimiseSquad_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player","in":"player17"}')
  #   end
  #
  #   it 'should output the player in current squad with fewest projected points', type: :request do
  #     (1..4).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
  #       end
  #     end
  #     Player.create(playerdata: "player13", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
  #     Player.create(playerdata: "player14", teamid: 10, position: "Goalkeeper", price: 1, projected_points: 7)
  #     Player.create(playerdata: "player15", teamid: 11, position: "Goalkeeper", price: 1, projected_points: 8)
  #     Player.create(playerdata: "player16", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 3)
  #     Player.create(playerdata: "player17", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 5)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     get optimiseSquadpath(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to include('{"out":"player13","in":"player17"}')
  #   end
  #
  #   it 'should output a new squad based on latest transfer', type: :request do
  #     (1..4).each do |i|
  #       3.times do
  #         Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
  #       end
  #     end
  #     Player.create(playerdata: "player13", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
  #     Player.create(playerdata: "player14", teamid: 10, position: "Goalkeeper", price: 1, projected_points: 7)
  #     Player.create(playerdata: "player15", teamid: 11, position: "Goalkeeper", price: 1, projected_points: 8)
  #     Player.create(playerdata: "player16", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 3)
  #     Player.create(playerdata: "player17", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 5)
  #     squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #     get transfers_path(squad: squad, cash: 10)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to eq('{"transfer":{"out":"player13","in":"player17"},"new_squad":[1,2,3,4,5,6,7,8,9,10,11,12,14,15,17]}')
  #
  #   end
  # end
  #
  #   describe 'parameter validation' do
  #     it 'should throw an error if no parameter is provided', type: :request do
  #       get transfers_path(cash: 10)
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq "Invalid parameters"
  #     end
  #
  #     it 'should throw an error if squad is blank', type: :request do
  #       get transfers_path(squad: '', cash: 10)
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq "Invalid parameters"
  #     end
  #
  #     it 'should throw an error if squad is not the correct size', type: :request do
  #       squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14]"
  #       get transfers_path(squad: squad, cash: 10)
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq "Invalid parameters"
  #     end
  #
  #     it 'should throw an error if £ in the bank is not provided', type: :request do
  #       squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #       get transfers_path(squad: squad)
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq("Invalid parameters")
  #     end
  #
  #     it 'should throw an error if £ in the bank is blank', type: :request do
  #       squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #       get transfers_path(squad: squad, cash: '')
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq("Invalid parameters")
  #     end
  #
  #     it 'should throw an error if £ in the bank is non-numeric', type: :request do
  #       squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
  #       get transfers_path(squad: squad, cash: '123abc')
  #       expect(response.status).to eq(400)
  #       expect(response.content_type).to eq(Mime::JSON)
  #       expect(response.body).to eq("Invalid parameters")
  #     end
  #   end

end



    # it 'should throw an error if new squad is blank', type: :request do
    #   get suggested_team_path(new_squad: '')
    #   expect(response.status).to eq(400)
    #   expect(response.content_type).to eq(Mime::JSON)
    #   expect(response.body).to eq "Invalid new squad parameters"
    # end
    #
    # it 'should throw an error if no new squad is provided', type: :request do
    #     get suggested_team_path
    #     expect(response.status).to eq(400)
    #     expect(response.content_type).to eq(Mime::JSON)
    #     expect(response.body).to eq "Invalid new squad parameters"
    # end
    #
    # it 'should throw an error if new squad is not the correct size', type: :request do
    #   squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14]"
    #   get suggested_team_path(new_squad: squad)
    #   expect(response.status).to eq(400)
    #   expect(response.content_type).to eq(Mime::JSON)
    #   expect(response.body).to eq "Invalid new squad parameters"
    # end
