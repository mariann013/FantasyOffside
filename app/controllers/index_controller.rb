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

  def createSquad
    if IndexHelper.parametersValid(params)
      squadArray = JSON.parse(params[:squad])
      self.transfers()
    else
      render json: "Invalid parameters", status: 400
    end
  end


  def transfers
    if IndexHelper.parametersValid(params)
      squadArray = JSON.parse(params[:squad])
      pointsHash = {}
      i = 0
      while i <= squadArray.length
        Player.where(id: squadArray[i]).find_each do |player|
          pointsHash[player.id] = player.projected_points
        end
        i += 1
      end
      newHash = pointsHash.sort_by {|_key, value| value}.first
      playerOut = Player.find(newHash[0])
      playerIn = IndexHelper.getPlayerIn(squadArray, playerOut, params[:cash])
      squadArray.delete(playerOut.id)
      newSquad = squadArray
      newSquad << playerIn.id

      data = {
        transfer: {
          out: playerOut.playerdata,
          in: playerIn.playerdata
        },
        new_squad: newSquad
      }
      render json: data, status: 200
    else
      render json: "Invalid parameters", status: 400
    end
  end

  def suggested_team

    render json: new_team, status: 200

  end

end
