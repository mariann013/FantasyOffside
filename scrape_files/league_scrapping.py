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

base = "http://fantasy.premierleague.com/"
html = urllib.urlopen(base).read()
soup = BeautifulSoup(html)
#scrape the website for the games played and points
games_played = soup.findAll("td", {"class":"col-pld"})
points = soup.findAll("td", {"class":"col-pts"})
#create an empty list for team names
team = []
#Find all of the team names and append them to the list
for text in soup.find_all('table', {"class":'leagueTable'}):
    for links in text.find_all('a'):
        team.append(links.text.strip())

i=0
while i < 20:
    cursor.execute("INSERT INTO league_table VALUES (%s, %s, %s, %s, %s)",
        (i, teamid, position, price))
    league_table.write(str(i+1) + "," + team[i] + "," + games_played[i].text + "," + points[i].text + "\n")
    sys.stdout.write(".")
    sys.stdout.flush()
    i +=1

print "League table scraped"
