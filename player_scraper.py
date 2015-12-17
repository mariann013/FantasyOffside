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
