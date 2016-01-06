require 'watir'

module SquadScraper

  def self.getSquadJSON(fplid)
    squad_ids = scrapeSquad(fplid)
    squadJSON = makeSquadArrayByPosition(squad_ids)
    return {
      squad: squadJSON,
      playerids: squad_ids,
      # formation: "",
      # captain: "",
      # vicecaptain: "",
      cash: 5.2
    }

  end

  private

  def self.scrapeSquad(fplid)
    squad = []
    url = "http://fantasy.premierleague.com/entry/#{fplid}/event-history/16/"
    browser = Watir::Browser.new :phantomjs
    browser.goto(url)
    rows = browser.table(:id, "ismTeamDisplayData").rows
    for i in 1..(rows.length-1)
      link_str = rows[i].cells[1].link(:class, 'ismInfo ismViewProfile JS_ISM_INFO').href
      squad << link_str.split("#").last.to_i
    end
    browser.close
    squad
  end



  def self.makeSquadArrayByPosition(squad_ids)
    squad_with_positions = {
      Goalkeeper: [],
      Defender: [],
      Midfielder: [],
      Forward: [],
    }
    new_squad = squad_ids.map { |playerid| Player.find(playerid) }
    newer_squad = new_squad[0,11]
    subs = new_squad[11,4]
    newer_squad.each do |player|
      player = PlayerFormatter.format(player.id)
      squad_with_positions[player[:position].to_sym] << player
    end
    lineup = {
      goalkeeper: nil,
      defenders: [],
      midfielders: [],
      forwards: [],
      substitutes: []
    }
    lineup[:goalkeeper] = squad_with_positions[:Goalkeeper].pop
    noOfDefenders = squad_with_positions[:Defender].count
    noOfDefenders.times { lineup[:defenders] << squad_with_positions[:Defender].shift }
    noOfMidfielders = squad_with_positions[:Midfielder].count
    noOfMidfielders.times { lineup[:midfielders] << squad_with_positions[:Midfielder].shift }
    noOfForwards = squad_with_positions[:Forward].count
    noOfForwards.times { lineup[:forwards] << squad_with_positions[:Forward].shift }

    subs.each do |player|
      player = PlayerFormatter.format(player.id)
      lineup[:substitutes] << player
    end
    lineup
  end

end
