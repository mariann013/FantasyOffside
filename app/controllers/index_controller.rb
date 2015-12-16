require "watir"

class IndexController < ApplicationController

  def squadid
  @squad = []
   url = "http://fantasy.premierleague.com/entry/#{params[:fplid]}/event-history/16/"
   browser = Watir::Browser.new :phantomjs
   browser.goto(url)
   rows = browser.table(:id, "ismTeamDisplayData").rows
   for i in 1..(rows.length-1)
     link_str = rows[i].cells[1].link(:class, 'ismInfo ismViewProfile JS_ISM_INFO').href
     @squad << link_str.split("#").last
   end
   browser.close
 end

end
