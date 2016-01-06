require './lib/modules/player_json_formatter.rb'

module IndexHelper

  def self.getOptimisedSquadJSON(squadArray, cash)
    transfers = transfers(squadArray, cash)
    squadArray = updateSquadForTransfers(squadArray, transfers)
    updated_cash = calc_cash(transfers, cash).round(1)
    lineup = pickLineup(squadArray)
    # formation = getFormation(lineup)
    return {
      squad: lineup,
      transfers: transfers,
      formation: "",
      captain: "",
      vicecaptain: "",
      cash: updated_cash
    }
  end

  private

  def self.pickLineup(squadArray)
    squad_with_positions = {
      Goalkeeper: [],
      Defender: [],
      Midfielder: [],
      Forward: []
    }
    new_squad = squadArray.map { |playerid| Player.find(playerid)  }
    new_squad.each do |player|
      squad_with_positions[player.position.to_sym] << player
    end
    lineup = {
      goalkeeper: nil,
      defenders: [],
      midfielders: [],
      forwards: [],
      substitutes: []
    }
    squad_with_positions[:Goalkeeper].sort! { |a, b| a.projected_points <=> b.projected_points }
    lineup[:goalkeeper] = squad_with_positions[:Goalkeeper].pop
    lineup[:substitutes] << squad_with_positions[:Goalkeeper].pop
    squad_with_positions[:Defender].sort! { |a, b| a.projected_points <=> b.projected_points }
    3.times{ lineup[:defenders] << squad_with_positions[:Defender].pop }
    squad_with_positions[:Midfielder].sort! { |a, b| a.projected_points <=> b.projected_points }
    3.times{ lineup[:midfielders] << squad_with_positions[:Midfielder].pop }
    squad_with_positions[:Forward].sort! { |a, b| a.projected_points <=> b.projected_points }
    lineup[:forwards] << squad_with_positions[:Forward].pop
    remaining_players = squad_with_positions[:Defender]+squad_with_positions[:Midfielder]+squad_with_positions[:Forward]
    remaining_players.sort! { |a, b| a.projected_points <=> b.projected_points }
    3.times { lineup[:substitutes] << remaining_players.shift }
    remaining_players.each do |player|
      string = player.position
      position = string.downcase.pluralize
      lineup[position.to_sym] << player
    end
    return lineup
  end



  def self.calc_cash(transfers, cash)
    cash.to_f + transfers[:out][:price].to_f - transfers[:in][:price].to_f
  end

  def self.updateSquadForTransfers(squadArray, transfers)
    squadArray.delete(transfers[:out][:id])
    squadArray << transfers[:in][:id]
  end

  def self.transfers(squadArray, cash)
    pointsHash = {}
    i = 0
    while i <= squadArray.length
      Player.where(id: squadArray[i]).find_each do |player|
        pointsHash[player.id] = player.projected_points/player.price
      end
      i += 1
    end
    newHash = pointsHash.sort_by {|_key, value| value }.first
    playerInId = getPlayerInId(squadArray, newHash[0], cash)

    return {
      out: PlayerFormatter.format(newHash[0]),
      in: PlayerFormatter.format(playerInId)
    }
  end

  def self.getPlayerInId(squad, playerOutId, cash)
      playerOut = Player.find(playerOutId)
      cashConstraint = playerOut.price + cash.to_f
      i = 0
      playerList = Player.order('projected_points desc')
      playerIn = playerList[i]
      while playerInIsInvalid(playerOut, playerIn, cashConstraint, squad)
        i += 1
        playerIn = playerList[i]
      end
      playerIn.id
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

  def self.parametersValid(params)
    if params[:squad] && params[:cash]
      squadValid(params[:squad]) && cashValid(params[:cash])
    else
      false
    end
  end
end
