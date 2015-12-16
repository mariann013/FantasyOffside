import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os

#########################################################################
# Extract all of the fixture and result information from the website #
#########################################################################
base = "http://fantasy.premierleague.com/fixtures/"
#Create a loop to run through the 38 gameweeks
week = 1
fix_file = open('fixtures.txt', 'w')
while week < 39:
    myurl = base + str(week)
    print myurl
    html = urllib.urlopen(myurl).read()
    soup = BeautifulSoup(html)
    fixture_table = soup.find("table", {"class":"ismFixtureTable"})
    #scrape the website for the games played and points
    hometeam = soup.findAll("td", {"class":"ismHomeTeam"})
    awayteam = soup.findAll("td", {"class":"ismAwayTeam"})

    i = 0

    #Keep looping until the code fails
    while True:
            try:
                    fix_file.write(str(week) + ',' + hometeam[i].text + ',' + awayteam[i].text.strip() + '\n')
                    i += 1
            except:
                    break

    week += 1

fix_file.close()

print "Fixture data scraped"
