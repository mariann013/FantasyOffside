require_relative 'player_gameweek_total'

class Player < ActiveRecord::Base


  def self.update_gk
    player = Player.find(1)
    pid = player.id

    if player.position = "Goalkeeper"
      total_points = []
      PlayerGameweekTotal.where(playerid: pid).find_each do |player|
        total_points << player.total_points
      end
      average = total_points.inject{ |sum, el| sum + el }.to_i / total_points.size
      player.update(projected_points: average)


        # total_points = PlayerGameweekTotal.find_each(playerid: pid)
        # p total_points
        # total_points = PlayerGameweekTotal.find(player.id).pluck(:total_points)
    end
    #   i += 1
    # end
  end
end
