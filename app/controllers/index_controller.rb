require './lib/modules/squad_scraper.rb'

class IndexController < ApplicationController

  def getsquad
    # fplid = params[:fplid]
    # if fplid && fplid.length > 0 && fplid !~ /\D/
    # json = SquadScraper.getSquadJSON(fplid).to_json
    #   render json: json, status: :ok
    # else
    #   errJson = { error: "Invalid team id number" }.to_json
    #   render json: errJson, status: 400
    # end

    dummyJson = {
      squad: {
        goalkeeper: {id: 1, playerdata: "player01", image: "shirt_1_1.png", teamname: "team01", teamid: 1, position: "Goalkeeper", price: 0.5, projected_points: 2},
        defenders: [
          {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Defender", price: 1.5, projected_points: 5},
          {id: 4, playerdata: "player04", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Defender", price: 2.0, projected_points: 4},
          {id: 6, playerdata: "player06", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Defender", price: 3.0, projected_points: 3},
          {id: 7, playerdata: "player07", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Defender", price: 3.5, projected_points: 3}
        ],
        midfielders: [
          {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Midfielder", price: 4.0, projected_points: 3},
          {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Midfielder", price: 5.0, projected_points: 2},
          {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Midfielder", price: 5.5, projected_points: 5},
          {id: 12, playerdata: "player12", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Midfielder", price: 6.0, projected_points: 4}
        ],
        forwards: [
          {id: 15, playerdata: "player15", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Forward", price: 7.5, projected_points: 1},
          {id: 13, playerdata: "player13", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Forward", price: 6.5, projected_points: 3}
        ],
        substitutes: [
          {id: 2, playerdata: "player02", image: "shirt_2_1.png", teamname: "team02", teamid: 2, position: "Goalkeeper", price: 1.0, projected_points: 1},
          {id: 5, playerdata: "player05", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Defender", price: 2.5, projected_points: 1},
          {id: 9, playerdata: "player09", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Midfielder", price: 4.5, projected_points: 1},
          {id: 14, playerdata: "player14", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Forward", price: 7.0, projected_points: 1}
        ]
      },
      playerids: [1,3,4,6,7,8,10,11,12,15,13,2,5,9,14],
      formation: [1,4,4,2],
      # captain: {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Midfielder", price: 4.0, projected_points: 3},
      # vicecaptain: {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Midfielder", price: 5.0, projected_points: 2},
      cash: 5.2
    }
    render json: dummyJson, status: :ok
  end

  def optimiseSquad
  #   if IndexHelper.parametersValid(params)
  #     squadArray = JSON.parse(params[:squad])
  #     cash = (params[:cash])
  #     json = IndexHelper.getOptimisedSquadJSON(squadArray, cash).to_json
  #     render json: json, status: :ok
  #   else
  #     render json: { error: "Invalid parameters" }, status: 400
  #   end
    dummyJson = {
      squad: {
        goalkeeper: {id: 1, playerdata: "player01", image: "shirt_1_1.png", teamname: "team01", teamid: 1, position: "Goalkeeper", price: 0.5, projected_points: 2},
        defenders: [
          {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Defender", price: 1.5, projected_points: 5},
          {id: 4, playerdata: "player04", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Defender", price: 2.0, projected_points: 4},
          {id: 6, playerdata: "player06", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Defender", price: 3.0, projected_points: 3},
          {id: 7, playerdata: "player07", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Defender", price: 3.5, projected_points: 3}
        ],
        midfielders: [
          {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Midfielder", price: 5.5, projected_points: 5},
          {id: 12, playerdata: "player12", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Midfielder", price: 6.0, projected_points: 4},
          {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Midfielder", price: 4.0, projected_points: 3},
          {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Midfielder", price: 5.0, projected_points: 2}
        ],
        forwards: [
          {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "Forward", price: 8.5, projected_points: 3},
          {id: 13, playerdata: "player13", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Forward", price: 6.5, projected_points: 3}
        ],
        substitutes: [
          {id: 2, playerdata: "player02", image: "shirt_2_1.png", teamname: "team02", teamid: 2, position: "Goalkeeper", price: 1.0, projected_points: 1},
          {id: 5, playerdata: "player05", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Defender", price: 2.5, projected_points: 1},
          {id: 14, playerdata: "player14", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Forward", price: 7.0, projected_points: 1},
          {id: 9, playerdata: "player09", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Midfielder", price: 4.5, projected_points: 1}
        ]
      },
      transfers: {
        out: {id: 15, playerdata: "player15", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Forward", price: 7.5, projected_points: 1},
        in: {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "Forward", price: 8.5, projected_points: 3}
      },
      formation: [1,4,4,2],
      captain: {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Midfielder", price: 5.5, projected_points: 5},
      vicecaptain: {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Defender", price: 1.5, projected_points: 5},
      cash: 4.2
    }

    render json: dummyJson, status: :ok
  end

end
