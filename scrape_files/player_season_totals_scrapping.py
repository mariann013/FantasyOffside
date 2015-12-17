import json
import urllib
import re
import io
from bs4 import BeautifulSoup
import os

#####################################################################
# Extract all of the player based information from the website #
#####################################################################
i = 1
while i < 650:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) +
"/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
#Use the json command to read in the json file
        data = json.load(htmltext)
        goalsscored = str(data["goals_scored"])
        # print goalsscored
        goalsassisted = str(data["assists"])
        # print goalsassisted
        cleansheets = str(data["clean_sheets"])
        # print cleansheets
        goalsconceded = str(data["goals_conceded"])
        # print goalsconceded
        owngoals = str(data["own_goals"])
        # print owngoals
        yellowcards = str(data["yellow_cards"])
        # print yellowcards
        redcards = str(data["red_cards"])
        # print redcards
        minutesplayed = data["minutes"]
        # print minutesplayed
        #Open the file using the io.open with encoding='utf8' to counteract irregual characters
        myfile = io.open("player_history.txt", "a", encoding='utf8')
        #Append the data to the file
    print i
    i += 1
print "Player data scraped"
##############################
