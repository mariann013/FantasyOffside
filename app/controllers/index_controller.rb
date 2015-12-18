require './lib/modules/squad_scraper.rb'

class IndexController < ApplicationController

  def getsquad
    if params[:fplid] == ""
      render json: "Must provide team id", status: 400
    elsif (params[:fplid] =~ /[^0-9]/) == nil
      render json: SquadScraper.getSquadJSON(params[:fplid]), status: :ok
    else
      render json: "Invalid team id number", status: 400
    end
  end
end
