module PlayerFormatter

  def self.format(playerid)
    player = Player.find(playerid)
    team = Team.find(player.teamid)
    image = get_image(player.position, team.id)
    return {
      id: playerid,
      playerdata: player.playerdata,
      image: image,
      teamname: team.name,
      teamid: player.teamid,
      position: player.position,
      price: player.price,
      projected_points: player.projected_points
    }
  end

  private

  def self.get_image(player_position, teamid)
    image_string = "shirt_" + teamid.to_s
    if player_position == "Goalkeeper"
      image_string = image_string + "_1.png"
    else
      image_string = image_string + ".png"
    end
  end
end
