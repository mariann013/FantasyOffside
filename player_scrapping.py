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
#Open the player file and make it writable
myfile = open("player_history.txt", "w")
myfile.close()
#Create a file to contain all the numbers for which there was errors.
errfile = open("errfile.txt", "w")
errfile.close()
#Website from which to scrape
while i < 650:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) +
"/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
#Use the json command to read in the json file
        data = json.load(htmltext)
        #Extract the score history from the json file
        scoredata = data["fixture_history"]["all"]
        # print scoredata
        #Extract the player names
        playerdata = data["first_name"] + " " + data["second_name"]
        #Extract player team
        teamname = data["team_name"]
        #Extract player position
        teamid = data["team_id"]
        position = data["type_name"]
        #Extract the players price
        price = data["now_cost"]/10.0
        #Percentage selected
        selected = data["selected_by"]
        # print selected
        form = data["form"]
        # print form
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
        minutesplayed = str(data["minutes"])
        # print minutesplayed
        #Open the file using the io.open with encoding='utf8' to counteract irregual characters
        myfile = io.open("player_history.txt", "a", encoding='utf8')
        #Append the data to the file
        for datapoint in scoredata:
            mystring = str(datapoint)
            # print mystring
            #Clean the data strings
            mystring1 = mystring.replace("[", "")
            # print mystring1
            mystring2 = mystring1.replace("u'", "")
            # print mystring2
            mystring3 = mystring2.replace("]", "")
            # print mystring3
            mystring4 = mystring3.replace("'", "")

            #Write the data to the file
            myfile.write(mystring4 + "," + playerdata + "," + teamname + "," + "," + team_id + position + "," + selected + "," + form + "," + goalsscored + "," + goalsassisted + "," + cleansheets + "," + goalsconceded + "," + owngoals + "," + yellowcards + "," + redcards + "," + minutesplayed + "," + str(price) + ',' + str(i) + "\n")
    except:
            # Write all of the numbers for which there was errors to a file
            # print "it didnt work"
            errfile = open("errfile.txt", "a")
            errfile.write(str(i) + "\n")
            pass
    print i
    i += 1
print "Player data scraped"
##############################
