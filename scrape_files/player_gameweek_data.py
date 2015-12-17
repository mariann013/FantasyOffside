import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os

#####################################################################
# Extract all of the player stats based information from the website #
#####################################################################
j = 0
i = 1
while i < 20:
   htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) + "/")
#Use the json command to read in the json file
   data = json.load(htmltext)
   #Extract the score history from the json file
   playerid = data["id"]
   n = 15
   while n > 10:
        scoredata       = data["fixture_history"]["all"][n]
        gameweek        = scoredata[1]
        minutes_played  = scoredata[3]
        goals_scored    = scoredata[4]
        assists         = scoredata[5]
        clean_sheets    = scoredata[6]
        goals_conceded  = scoredata[7]
        own_goals       = scoredata[8]
        penalties_saved = scoredata[9]
        penalties_missed = scoredata[10]
        yellow_cards    = scoredata[11]
        red_cards       = scoredata[12]
        saves           = scoredata[13]
        bonus_points    = scoredata[14]
        total_points    = scoredata[19]
        j += 1
        print (
                str(j) + "," +
                str(playerid) + "," +
                str(gameweek) + "," +
                str(minutes_played) + "," +
                str(goals_scored) + "," +
                str(assists) + "," +
                str(clean_sheets) + "," +
                str(goals_conceded) + "," +
                str(own_goals) + "," +
                str(penalties_saved) + "," +
                str(penalties_missed) + "," +
                str(yellow_cards) + "," +
                str(red_cards) + "," +
                str(saves) + "," +
                str(bonus_points) + "," +
                str(total_points)
            )
        n -= 1
   # print i
   i += 1
print "Player data scraped"
##############################
