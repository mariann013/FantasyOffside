require './lib/modules/squad_scraper.rb'

class IndexController < ApplicationController

  def getsquad
    render json: SquadScraper.getSquadJSON(params[:fplid]), status: :ok
  end

end
