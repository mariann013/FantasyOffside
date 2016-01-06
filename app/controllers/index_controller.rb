require './lib/modules/squad_scraper.rb'

class IndexController < ApplicationController

  def getsquad
    fplid = params[:fplid]
    p "FPLID: #{fplid}"
    if fplid && fplid.length > 0 && fplid !~ /\D/
    json = SquadScraper.getSquadJSON(fplid).to_json
      render json: json, status: :ok
    else
      errJson = { error: "Invalid team id number" }.to_json
      render json: errJson, status: 400
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
