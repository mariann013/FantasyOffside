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

  def optimiseSquad
    if IndexHelper.parametersValid(params)
      squadArray = JSON.parse(params[:squad])
      cash = (params[:cash])
      render json: IndexHelper.getOptimisedSquadJSON(squadArray, cash)
    else
      render json: "Invalid parameters", status: 400
    end
  end

end
