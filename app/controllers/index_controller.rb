require './lib/modules/squad_scraper.rb'

class IndexController < ApplicationController

  def getsquad
    fplid = params[:fplid]
    if fplid && fplid.length > 0 && fplid !~ /\D/
      render json: SquadScraper.getSquadJSON(params[:fplid]), status: :ok
    else
      render json: "Invalid team id number", status: 400
    end
  end

  def transfers
    if IndexHelper.parametersValid(params)
      squadArray = JSON.parse(params[:squad])
      playerOut = Player.find(squadArray.sample)
      playerIn = IndexHelper.getPlayerIn(squadArray, playerOut, params[:cash])
      transfer = {
        out: playerOut.playerdata,
        in: playerIn.playerdata
      }
      render json: transfer, status: 200
    else
      render json: "Invalid parameters", status: 400
    end
  end

end
