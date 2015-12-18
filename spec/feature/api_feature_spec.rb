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

    post getsquad_path(fplid: '0000000')
    expect(response.status).to eq(200)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq "[[\"test_player\",\"test_team\",\"Goalkeeper\",5.5]]"
  end

  it 'should throw an error is fplid is not a number', type: :request do
    post getsquad_path(fplid: 'abcdef')
    expect(response.status).to eq(400)
    expect(response.content_type).to eq(Mime::JSON)
    expect(response.body).to eq "Invalid team id number"
  end

end
