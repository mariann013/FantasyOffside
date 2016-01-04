import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os
import psycopg2
import urlparse
import sys

urlparse.uses_netloc.append("postgres")

url = urlparse.urlparse(os.environ["DATABASE_URL"])

conn = psycopg2.connect(
    database=url.path[1:],
    user=url.username,
    password=url.password,
    host=url.hostname,
    port=url.port
)

conn.autocommit = True
cursor = conn.cursor()
sys.stdout.write("Scraping players! ")
sys.stdout.flush()
j = 1
i = 0
while i < 650:
    i += 1
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) + "/")
    try:
        #Use the json command to read in the json file
        data = json.load(htmltext)
        #Extract the score history from the json file
        playerid = data["id"]
        # THE BELOW NUMBER REFERS TO THE GAMEWEEK IE GW 16 IS EQUAL TO N OF 15
        player_history = data["fixture_history"]["all"]
        n = len(player_history) - 1
        while n >= 0:
            scoredata = player_history[n]
            gameweek = scoredata[1]
            if gameweek >= 16:
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
                cursor.execute("INSERT INTO player_gameweek_totals VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    (j, playerid, gameweek, minutes_played, goals_scored, assists, clean_sheets, goals_conceded, own_goals, penalties_saved, penalties_missed, yellow_cards, red_cards, saves, bonus_points, total_points))
                sys.stdout.write(".")
                sys.stdout.flush()
                j += 1
            n -= 1
    except:
        pass
print " Done :)"
