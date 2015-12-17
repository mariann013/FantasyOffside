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
i = 1
while i < 650:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) +"/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
#Use the json command to read in the json file
        data = json.load(htmltext)
        goals_scored = data["goals_scored"]
        goals_assisted = data["assists"]
        clean_sheets = data["clean_sheets"]
        goals_conceded = data["goals_conceded"]
        own_goals = data["own_goals"]
        yellow_cards = data["yellow_cards"]
        red_cards = data["red_cards"]
        minutes_played = data["minutes"]

        cursor.execute("INSERT INTO player_season_totals VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (i, goals_scored, goals_assisted, clean_sheets, goals_conceded, own_goals, yellow_cards, red_cards, minutes_played))
    except:
        pass

    sys.stdout.write(".")
    sys.stdout.flush()

    i += 1
print " Done :)"
