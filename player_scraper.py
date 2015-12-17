import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os
import psycopg2
import sys

conn_str = "host='localhost' dbname='FantasyOffside_development'"
conn = psycopg2.connect(conn_str)
conn.autocommit = True
cursor = conn.cursor()

sys.stdout.write("Scraping players! ")
sys.stdout.flush()

i = 1
while i < 635:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) + "/")
    try:
        data = json.load(htmltext)
        teamid = str(data["team_id"])
        playername = data["first_name"] + " " + data["second_name"]
        cursor.execute("INSERT INTO players VALUES (%s, %s, %s)",
            (i, playername, teamid))
    except:
        pass

    sys.stdout.write(".")
    sys.stdout.flush()

    i += 1

print " Done :)"
