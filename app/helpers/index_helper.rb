module IndexHelper

    def self.getPlayerIn(squad, playerOut, cash)
      cashConstraint = playerOut.price + cash.to_f
      # numToSkip = rand(Player.count)
      # playerIn = Player.offset(numToSkip).first
      playerIn = Player.order('projected_points desc').first
      i = 1
      while playerInIsInvalid(playerOut, playerIn, cashConstraint, squad)
        playerIn = Player.order('projected_points desc').offset(i).first
        i += 1
      end
      playerIn
    end

    private

    def self.playerInIsInvalid(playerOut, playerIn, cashConstraint, squad)
      return true if squadContains(playerIn, squad)
      return true unless positionsMatch(playerIn, playerOut)
      return true unless withinBudget(playerIn, cashConstraint)
      return true unless withinMaxPlayersPerTeam(playerIn, playerOut, squad)
      false
    end

    def self.withinMaxPlayersPerTeam(playerIn, playerOut, squad)
      squad.delete(playerOut.id)
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
      cash.length > 0 && cash !~ /\D/
    end

end
