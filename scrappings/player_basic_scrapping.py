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
myfile = open("player_data.txt", "w")
myfile.close()
#Create a file to contain all the numbers for which there was errors.
errfile = open("errfile.txt", "w")
errfile.close()
#Website from which to scrape
while i < 5:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) +
"/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
#Use the json command to read in the json file
        data = json.load(htmltext)
        #Extract the score history from the json file

        # print scoredata
        #Extract the player names
        playerdata = data["first_name"] + " " + data["second_name"]
        #Extract player team
        teamname = data["team_name"]
        #Extract player position
        position = data["type_name"]
        #Extract the players price

        # print minutesplayed
        #Open the file using the io.open with encoding='utf8' to counteract irregual characters
    myfile = io.open("player_data.txt", "a", encoding='utf8')
        #Append the data to the file


            #Write the data to the file

myfile.write(playerdata + "," + teamname + "," + position + "\n")

    except:
            # Write all of the numbers for which there was errors to a file
            # print "it didnt work"
            errfile = open("errfile.txt", "a")
            errfile.write(str(i) + "\n")
            pass
    print i
    i += 1
print "Player data scraped bitches"
##############################
