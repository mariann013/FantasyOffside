import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os


#################################################
# Extract the league table from the website #
#################################################
base = "http://fantasy.premierleague.com/transfers/"
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

league_table = open("league_table.txt", "w")
league_table.close()

league_table = open("league_table.txt", "a")
#print out the league table
i=0
while i < 20:
    league_table.write(str(i+1) + "," + team[i] + "," + games_played[i].text + "," + points[i].text + "\n")

    i +=1
league_table.close()

print "League table scraped"
print "All data scraped"
