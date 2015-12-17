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
myfile = open("players.txt", "w")
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
        #Extract the player names
        playerdata = data["first_name"] + " " + data["second_name"]
        #Extract player team id
        teamid = data["team_id"]
        #Extract player position
        position = data["type_name"]
        #Extract player price
        price = data["now_cost"]/10.0
        #Open the file using the io.open with encoding='utf8' to counteract irregual characters
        myfile = io.open("players.txt", "a", encoding='utf8')
        #Write the data to the file
        myfile.write(str(i) + "," + playerdata + "," + position + "," + str(teamid) + "," + str(price) +  "\n")
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
