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
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) + "/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
        #Use the json command to read in the json file
        data = json.load(htmltext)
        #Extract the player names
        playerdata = data["first_name"] + " " + data["second_name"]
        #Extract player team id
        teamid = data["team_id"]
        #Extract player position
        position = data["type_name"]
        #Extract player price
        price = data["now_cost"]/10.0
        cursor.execute("INSERT INTO players VALUES (%s, %s, %s, %s, %s)",
            (i, playerdata, teamid, position, price))
    except:
        pass

    sys.stdout.write(".")
    sys.stdout.flush()

    i += 1
print " Done :)"
