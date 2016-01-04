require_relative 'player_gameweek_total'

class Player < ActiveRecord::Base


  def self.update_gk
    i = 1
    while i < 650
      player = Player.find(i)
      if player.position = "Goalkeeper"
        total_points = []
        PlayerGameweekTotal.where(playerid: player.id).find_each do |player|
          total_points << player.total_points
        end
        average = total_points.inject{ |sum, el| sum + el }.to_i / total_points.size
      end
      player.projected_points = average
      player.save
      i += 1
    end
  end

end
