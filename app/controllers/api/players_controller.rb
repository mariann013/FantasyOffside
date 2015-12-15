module API
  class PlayersController < ApplicationController
    def index
      players = Player.all
      if team = params[:team]
        players = players.where(team: team)
      end
      render json: players, status: :ok #see Rails 4 Patterns course to learn about ActiveRecord Serializers
    end

    def show
      player = Player.find(params[:id])
      render json: player, status: :ok
    end

  end
end
