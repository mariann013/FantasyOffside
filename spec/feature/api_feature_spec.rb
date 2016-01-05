require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe 'API' do

  let(:browser) { double(:browser, goto: true, close: true) }
  let(:row) { double(:row) }

  before :each do
    DatabaseCleaner.clean
  end

  describe 'squad scraping' do
    it 'scrapes the user\'s squad and returns details', type: :request do
      Player.create(playerdata: "test_player", teamid: 1, position: "Goalkeeper", price: 5.5)
      Team.create(name: "test_team")

      allow(Watir::Browser).to receive(:new).and_return(browser)
      allow(browser).to receive_message_chain("table.rows") { ["", row] }
      allow(row).to receive_message_chain(:cells, :[], :link, :href) { "1" }

      get getsquad_path(fplid: '0000000')
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq "[[\"test_player\",\"test_team\",\"Goalkeeper\",5.5]]"
    end

    it 'should throw an error if fplid is not a number', type: :request do
      get getsquad_path(fplid: 'abcdef')
      expect(response.status).to eq(400)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq "Invalid team id number"
    end

    it 'should throw an error if a blank fplid is provided', type: :request do
      get getsquad_path(fplid: '')
      expect(response.status).to eq(400)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq "Invalid team id number"
    end

    it 'should throw an error if no parameter is provided', type: :request do
      get getsquad_path()
      expect(response.status).to eq(400)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq "Invalid team id number"
    end
  end

  describe 'getting transfers' do
    it 'should suggest transfer which excludes current squad', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
        end
      end
      Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      allow_any_instance_of(Array).to receive(:sample).and_return(1)
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player","in":"player16"}')
    end

    it 'should suggest a transfer of correct position', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
        end
      end
      Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)
      Player.create(playerdata: "player17", teamid: 1, position: "Defender", price: 1)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      allow_any_instance_of(Array).to receive(:sample).and_return(1)
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player","in":"player16"}')
    end

    it 'should suggest transfer that doesn\'t exceed cash constraint', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
        end
      end
      Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 11)
      Player.create(playerdata: "player17", teamid: 1, position: "Goalkeeper", price: 12)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      allow_any_instance_of(Array).to receive(:sample).and_return(1)
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player","in":"player16"}')
    end

    it 'should suggest a transfer that doesn\'t exceed max players per team', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1)
        end
      end
      Player.create(playerdata: "player16", teamid: 2, position: "Goalkeeper", price: 1)
      Player.create(playerdata: "player17", teamid: 6, position: "Goalkeeper", price: 1)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      allow_any_instance_of(Array).to receive(:sample).and_return(1)
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player","in":"player17"}')
    end

    it 'should suggest transfer which yields maximum projected points', type: :request do
      (1..5).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
        end
      end
      Player.create(playerdata: "player16", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
      Player.create(playerdata: "player17", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 6)
      Player.create(playerdata: "player18", teamid: 6, position: "Goalkeeper", price: 12, projected_points: 7)
      Player.create(playerdata: "player19", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 5)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      allow_any_instance_of(Array).to receive(:sample).and_return(1)
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player","in":"player17"}')
    end

    it 'should output the player in current squad with fewest projected points', type: :request do
      (1..4).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
        end
      end
      Player.create(playerdata: "player13", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
      Player.create(playerdata: "player14", teamid: 10, position: "Goalkeeper", price: 1, projected_points: 7)
      Player.create(playerdata: "player15", teamid: 11, position: "Goalkeeper", price: 1, projected_points: 8)
      Player.create(playerdata: "player16", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 3)
      Player.create(playerdata: "player17", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 5)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to include('{"out":"player13","in":"player17"}')
    end

    it 'should output a new squad based on latest transfer', type: :request do
      (1..4).each do |i|
        3.times do
          Player.create(playerdata: "player", teamid: i, position: "Goalkeeper", price: 1, projected_points: 5)
        end
      end
      Player.create(playerdata: "player13", teamid: 6, position: "Goalkeeper", price: 1, projected_points: 4)
      Player.create(playerdata: "player14", teamid: 10, position: "Goalkeeper", price: 1, projected_points: 7)
      Player.create(playerdata: "player15", teamid: 11, position: "Goalkeeper", price: 1, projected_points: 8)
      Player.create(playerdata: "player16", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 3)
      Player.create(playerdata: "player17", teamid: 14, position: "Goalkeeper", price: 1, projected_points: 5)
      squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
      get transfers_path(squad: squad, cash: 10)
      expect(response.status).to eq(200)
      expect(response.content_type).to eq(Mime::JSON)
      expect(response.body).to eq('{"transfer":{"out":"player13","in":"player17"},"new_squad":[1,2,3,4,5,6,7,8,9,10,11,12,14,15,17]}')

    end
  end

    describe 'parameter validation' do
      it 'should throw an error if no parameter is provided', type: :request do
        get transfers_path(cash: 10)
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq "Invalid parameters"
      end

      it 'should throw an error if squad is blank', type: :request do
        get transfers_path(squad: '', cash: 10)
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq "Invalid parameters"
      end

      it 'should throw an error if squad is not the correct size', type: :request do
        squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14]"
        get transfers_path(squad: squad, cash: 10)
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq "Invalid parameters"
      end

      it 'should throw an error if £ in the bank is not provided', type: :request do
        squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
        get transfers_path(squad: squad)
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq("Invalid parameters")
      end

      it 'should throw an error if £ in the bank is blank', type: :request do
        squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
        get transfers_path(squad: squad, cash: '')
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq("Invalid parameters")
      end

      it 'should throw an error if £ in the bank is non-numeric', type: :request do
        squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
        get transfers_path(squad: squad, cash: '123abc')
        expect(response.status).to eq(400)
        expect(response.content_type).to eq(Mime::JSON)
        expect(response.body).to eq("Invalid parameters")
      end
    end

  # describe 'selecting team' do
  #   it 'should allow only one goalkeeper to be selected in team', type: :request do
  #     Player.create(playerdata: "goalkeeper1", teamid: 1, position: "Goalkeeper", price: 1, projected_points: 10)
  #     Player.create(playerdata: "goalkeeper2", teamid: 1, position: "Goalkeeper", price: 1, projected_points: 5)
  #     squad = "[1,2]"
  #     get suggested_team_path(new_squad: squad)
  #     expect(response.status).to eq(200)
  #     expect(response.content_type).to eq(Mime::JSON)
  #     expect(response.body).to eq('{"goalkeeper":"goalkeeper1"}')
  #     expect(response.body).not_to eq('{"goalkeeper":"goalkeeper2"}')
  #   end
  # end
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
