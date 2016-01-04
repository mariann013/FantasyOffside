require_relative 'player_gameweek_total'

class Player < ActiveRecord::Base


  def self.update_projections
    i = 1
    while i <= Player.count
      player = Player.find(i)
      total_points = []
      PlayerGameweekTotal.where(playerid: player.id).find_each do |player|
        total_points << player.total_points
      end
      if total_points.size != 0
        average = total_points.inject{ |sum, el| sum + el }.to_i / total_points.size
        player.projected_points = average
        player.save
      else
        player.projected_points = 0
        player.save
      end
      i += 1
    end
  end

end
