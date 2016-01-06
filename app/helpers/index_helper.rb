module IndexHelper

  def self.getOptimisedSquadJSON(squadArray, cash)
    {
        squad: {
          goalkeeper: {id: 1, playerdata: "player01", image: "shirt_1_1.png", teamname: "team01", teamid: 1, position: "Goalkeeper", price: 0.5, projected_points: 2},
          defenders: [
            {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Defender", price: 1.5, projected_points: 5},
            {id: 4, playerdata: "player04", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Defender", price: 2, projected_points: 4},
            {id: 6, playerdata: "player06", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Defender", price: 3, projected_points: 3},
            {id: 7, playerdata: "player07", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Defender", price: 3.5, projected_points: 3}
          ],
          midfielders: [
            {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Midfielder", price: 5.5, projected_points: 5},
            {id: 12, playerdata: "player12", image: "shirt_2.png", teamname: "team02", teamid: 2, position: "Midfielder", price: 6, projected_points: 4},
            {id: 8, playerdata: "player08", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Midfielder", price: 4, projected_points: 3},
            {id: 10, playerdata: "player10", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Midfielder", price: 5, projected_points: 2}
          ],
          forwards: [
            {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "Forward", price: 8.5, projected_points: 3},
            {id: 13, playerdata: "player13", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Forward", price: 6.5, projected_points: 3}
          ],
          substitutes: [
            {id: 2, playerdata: "player02", image: "shirt_2_1.png", teamname: "team02", teamid: 2, position: "Goalkeeper", price: 1, projected_points: 1},
            {id: 5, playerdata: "player05", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Defender", price: 2.5, projected_points: 1},
            {id: 14, playerdata: "player14", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Forward", price: 7, projected_points: 1},
            {id: 9, playerdata: "player09", image: "shirt_4.png", teamname: "team04", teamid: 4, position: "Midfielder", price: 4.5, projected_points: 1}
          ]
        },
        transfers: {
          out: {id: 15, playerdata: "player15", image: "shirt_5.png", teamname: "team05", teamid: 5, position: "Forward", price: 7.5, projected_points: 1},
          in: {id: 17, playerdata: "player17", image: "shirt_6.png", teamname: "team06", teamid: 6, position: "Forward", price: 8.5, projected_points: 2}
        },
        formation: [1,4,4,2],
        captain: {id: 11, playerdata: "player11", image: "shirt_1.png", teamname: "team01", teamid: 1, position: "Midfielder", price: 5.5, projected_points: 5},
        vicecaptain: {id: 3, playerdata: "player03", image: "shirt_3.png", teamname: "team03", teamid: 3, position: "Defender", price: 1.5, projected_points: 5},
        cash: 4.2
      }
  end

  private

  # def self.pickFormation(squadArray)
  #   i = 0
  #   while i <= squadArray.length
  #     Player.where(id: squadArray[i]).find_each do |player|
  #
  #       p player.projected_points
  #     end
  #     i += 1
  #   end
  #
  # end


  def self.updateSquadForTransfers(squadArray, transfers)
    squadArray.delete(transfers[:out][:id])
    squadArray << transfers[:in][:id]
  end

  def self.transfers(squadArray, cash)
    pointsHash = {}
    i = 0
    while i <= squadArray.length
      Player.where(id: squadArray[i]).find_each do |player|
        pointsHash[player.id] = player.projected_points
      end
      i += 1
    end
    newHash = pointsHash.sort_by {|_key, value| value }.first
    playerOut = Player.find(newHash[0])
    playerIn = getPlayerIn(squadArray, playerOut, cash)
    return {
      out: {
        id: playerOut.id,
        name: playerOut.playerdata,
        teamid: playerOut.teamid,
        price: playerOut.price
      },
      in: {
        id: playerIn.id,
        name: playerIn.playerdata,
        teamid: playerIn.teamid,
        price: playerIn.price
      }
    }
  end

  def self.getPlayerIn(squad, playerOut, cash)
      cashConstraint = playerOut.price + cash.to_f
      i = 0
      playerList = Player.order('projected_points desc')
      playerIn = playerList[i]
      while playerInIsInvalid(playerOut, playerIn, cashConstraint, squad)
        i += 1
        playerIn = playerList[i]
      end
      playerIn
  end

  def self.playerInIsInvalid(playerOut, playerIn, cashConstraint, squad)
    return true if squadContains(playerIn, squad)
    return true unless positionsMatch(playerIn, playerOut)
    return true unless withinBudget(playerIn, cashConstraint)
    return true unless withinMaxPlayersPerTeam(playerIn, playerOut, squad)
    false
  end


  def self.withinMaxPlayersPerTeam(playerIn, playerOut, squad)
    if playerIn.teamid == playerOut.teamid
      true
    else
      counts = {}
      squad.each do |playerId|
        teamid = Player.find(playerId).teamid
        if counts[teamid]
          counts[teamid] += 1
        else
          counts[teamid] = 1
        end
      end
      counts[playerIn.teamid].nil? || counts[playerIn.teamid] < 3
    end
  end

  def self.parametersValid(params)
    if params[:squad] && params[:cash]
      squadValid(params[:squad]) && cashValid(params[:cash])
    else
      false
    end
  end

  def self.squadContains(player, squad)
    squad.include? player.id
  end

  def self.positionsMatch(player1, player2)
    player1.position == player2.position
  end

  def self.withinBudget(player, budget)
    player.price <= budget
  end

  def self.squadValid(squad)
    begin
      parsedSquad = JSON.parse(squad)
    rescue JSON::ParserError => e
      return false
    end
    parsedSquad.length == 15
  end

  def self.cashValid(cash)
    cash.length > 0
    # && cash !~ /\D/
  end
end
