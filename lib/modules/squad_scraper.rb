require 'watir'

module SquadScraper

  def self.getSquadJSON(fplid)
    squad_ids = scrapeSquad(fplid)
    squadJSON = lookupSquadFromIds(squad_ids)
  end

  def self.scrapeSquad(fplid)
    squad = []
    url = "http://fantasy.premierleague.com/entry/#{fplid}/event-history/16/"
    browser = Watir::Browser.new :phantomjs
    browser.goto(url)
    rows = browser.table(:id, "ismTeamDisplayData").rows
    for i in 1..(rows.length-1)
      link_str = rows[i].cells[1].link(:class, 'ismInfo ismViewProfile JS_ISM_INFO').href
      squad << link_str.split("#").last
    end
    browser.close
    squad
  end

  def self.lookupSquadFromIds(squad_ids)
    # {
    #   squad: {
    #     gk: {name: "player01", teamid: 1, price: 0.5},
    #     defenders: [{name: "player03", teamid: 3, price: 1.5},{name: "player04", teamid: 4, price: 2},{name: "player06", teamid: 1, price: 3},{name: "player07", teamid: 2, price: 3.5}],
    #     midfielders: [{name: "player08", teamid: 3, price: 4},{name: "player10", teamid: 5, price: 5},{name: "player11", teamid: 1, price: 5.5},{name: "player12", teamid: 2, price: 6}],
    #     attackers: [{name: "player13", teamid: 3, price: 6.5},{name: "player15", teamid: 5, price: 7.5}],
    #     substitutes: {
    #       gk: {name: "player02", teamid: 2, price: 1},
    #       defenders: [{name: "player05", teamid: 5, price: 2.5}],
    #       midfielders: [{name: "player09", teamid: 4, price: 4.5}],
    #       attackers: [{name: "player14", teamid: 4, price: 7}]
    #     }
    #   },
    #   playerids: [1,3,4,6,7,8,10,11,12,13,15,2,5,9,14],
    #   formation: [1,4,4,2],
    #   captain: {name: "player08", teamid: 3, price: 4},
    #   vicecaptain: {name: "player10", teamid: 5, price: 5},
    #   cash: 100.0
    # }

    
    squadJson = squad_ids.map do |id|
      player = Player.find(id)
      team = Team.find(player.teamid)
      [player.playerdata, team.name, player.position, player.price]
    end
    squadJson
  end

end
