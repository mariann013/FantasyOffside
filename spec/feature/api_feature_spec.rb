require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe 'API' do

  let(:browser) { double(:browser, goto: true, close: true) }
  let(:row) { double(:row) }


  it 'scrapes the user\'s squad and returns details', type: :request do
    DatabaseCleaner.clean
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

  it 'should throw an error if no parameter is provided', type: :request do
    get transfers_path()
    expect(response.status).to eq(400)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq "No squad provided"
  end

  it 'should throw an error if squad is blank', type: :request do
    get transfers_path(squad: '')
    expect(response.status).to eq(400)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq "No squad provided"
  end

  it 'should throw an error if squad is not the correct size', type: :request do
    squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14]"
    get transfers_path(squad: squad)
    expect(response.status).to eq(400)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq "Invalid squad size"
  end

  it 'should suggest a transfer based on the provided squad', type: :request do
    DatabaseCleaner.clean

    Player.create(playerdata: "player1", teamid: 1, position: "Goalkeeper", price: 1)

    14.times do
      Player.create(playerdata: "player", teamid: 1, position: "Goalkeeper", price: 1)
    end

    Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)

    squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"

    allow_any_instance_of(Array).to receive(:sample).and_return(1)

    get transfers_path(squad: squad)

    expect(response.status).to eq(200)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq('{"out":"player1","in":"player16"}')
  end

  it 'should suggest a transfer in of the same position as the transfered out player', type: :request do
    DatabaseCleaner.clean

    Player.create(playerdata: "player1", teamid: 1, position: "Goalkeeper", price: 1)

    14.times do
      Player.create(playerdata: "player", teamid: 1, position: "Ball Bitch", price: 1)
    end

    Player.create(playerdata: "player16", teamid: 1, position: "Goalkeeper", price: 1)
    Player.create(playerdata: "player17", teamid: 1, position: "Ball Bitch", price: 1)

    squad = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"

    allow_any_instance_of(Array).to receive(:sample).and_return(1)

    get transfers_path(squad: squad)

    expect(response.status).to eq(200)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq('{"out":"player1","in":"player16"}')

  end

end
