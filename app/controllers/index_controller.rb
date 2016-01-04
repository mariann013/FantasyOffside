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
    squad = params[:squad]
    if squad && squad.length > 0
      squadArray = JSON.parse(squad)
      if squadArray.length < 15
        render json: "Invalid squad size", status: 400
      else
        playerOut = Player.find(squadArray.sample)
        numToSkip = rand(Player.count)
        playerIn = Player.offset(numToSkip).first
        while (squadArray.include? playerIn.id)
          numToSkip = rand(Player.count)
          playerIn = Player.offset(numToSkip).first
        end
        transfer = {
          out: playerOut.playerdata,
          in: playerIn.playerdata
        }
        render json: transfer, status: 200
      end
    else
      render json: "No squad provided", status: 400
    end
  end

end
