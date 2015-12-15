require 'test_helper'

class ListingPlayersTest < ActionDispatch::IntegrationTest

  setup { host! 'api.fantasyoffside.com' }

  test 'returns list of all players' do
    get '/players'
    assert_equal 200, response.status
    refute_empty response.body
  end

  test 'returns players filtered by team (play for Arsenal)' do
    player = Player.create!(name: 'Thierry Henry', team: 'Arsenal') #use fixtures or Factory girl if necessary
    player = Player.create!(name: 'Roy Keane', team: 'Manchester United')

    get '/players?team=Arsenal'
    assert_equal 200, response.status

    players = JSON.parse(response.body, symbolize_names: true)
    names = players.collect { |z| z[:name] }
    assert_includes names, 'Thierry Henry'
    refute_includes names, 'Roy Keane'
  end

  test 'returns player by id' do
    player = Player.create!(name: 'Steven Gerrard', team: 'Liverpool')
    get "/players/#{player.id}"
    assert_equal 200, response.status

    player_response = JSON.parse(response.body, symbolize_names: true)
    assert_equal player.name, player_response[:name]
  end

  test 'returns players in JSON' do
    get '/players', {}, { 'Accept' => Mime::JSON }
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end


end
