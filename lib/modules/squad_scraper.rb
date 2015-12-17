require 'watir'

module SquadScraper

  def self.getSquadJSON(fplid)
    squad_ids = scrapeSquad(fplid)
    squadJSON = lookupSquadFromIds(squad_ids)
  end

  def self.scrapeSquad(fplid)
    puts fplid
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
    squadJson = squad_ids.map do |id|
      player = Player.find(id)
      team = Team.find(player.teamid)
      [player.playerdata, team.name, player.position, player.price]
    end
    squadJson
  end

end
