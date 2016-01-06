# require 'database_cleaner'
#
# DatabaseCleaner.strategy = :truncation
#
# describe 'Feature: scraping the user\'s current squad' do
#   let(:browser) { double(:browser, goto: true, close: true) }
#   let(:row) { double(:row) }
#   before :each do
#     DatabaseCleaner.clean
#   end
#   it 'scrapes the user\'s squad and returns it in json format' do
#
#     Player.create(playerdata: "player01", teamid: 1, position: "gk", price: 0.5)
#     Player.create(playerdata: "player02", teamid: 2, position: "gk", price: 1)
#     Player.create(playerdata: "player03", teamid: 3, position: "def", price: 1.5)
#     Player.create(playerdata: "player04", teamid: 4, position: "def", price: 2)
#     Player.create(playerdata: "player05", teamid: 5, position: "def", price: 2.5)
#     Player.create(playerdata: "player06", teamid: 1, position: "def", price: 3)
#     Player.create(playerdata: "player07", teamid: 2, position: "def", price: 3.5)
#     Player.create(playerdata: "player08", teamid: 3, position: "mid", price: 4)
#     Player.create(playerdata: "player09", teamid: 4, position: "mid", price: 4.5)
#     Player.create(playerdata: "player10", teamid: 5, position: "mid", price: 5)
#     Player.create(playerdata: "player11", teamid: 1, position: "mid", price: 5.5)
#     Player.create(playerdata: "player12", teamid: 2, position: "mid", price: 6)
#     Player.create(playerdata: "player13", teamid: 3, position: "att", price: 6.5)
#     Player.create(playerdata: "player14", teamid: 4, position: "att", price: 7)
#     Player.create(playerdata: "player15", teamid: 5, position: "att", price: 7.5)
#     Team.create(name: "team01")
#     Team.create(name: "team02")
#     Team.create(name: "team03")
#     Team.create(name: "team04")
#     Team.create(name: "team05")
#
#     allow(Watir::Browser).to receive(:new).and_return(browser)
#     allow(browser).to receive_message_chain("table.rows") { ["", row] }
#     allow(row).to receive_message_chain(:cells, :[], :link, :href)
#       .and_return("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15")
#     get getsquad_path(fplid: '0000000')
#     expect(response.status).to eq(200)
#     expect(response.content_type).to eq(Mime::JSON)
#   end
# end
