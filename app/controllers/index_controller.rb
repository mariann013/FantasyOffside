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
    if !squad || squad == ""
      render json: "No squad provided", status: 400
    else
      render json: "Invalid squad size", status: 400
    end
  end

end
