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
while i < 5:
    htmltext = urllib.urlopen("http://fantasy.premierleague.com/web/api/elements/" + str(i) +
"/")
#Use a try-except block to ignore htmls that do not relate to players
    try:
#Use the json command to read in the json file
        data = json.load(htmltext)
        #Extract the score history from the json file
        scoredata = data["fixture_history"]["all"]
        #Extract the player names
        playerdata = data["first_name"] + " " + data["second_name"]
        print playerdata
        #Extract player team
        teamname = data["team_name"]
        #Extract player position
        position = data["type_name"]
        #Extract the players price
        price = data["now_cost"]/10.0
        #Percentage selected
        selected = data["selected_by"]
        # print selected
        form = data["form"]
        print form

        #Open the file using the io.open with encoding='utf8' to counteract irregual characters
        myfile = io.open("player_history.txt", "a", encoding='utf8')
        #Append the data to the file
        for datapoint in scoredata:
            mystring = str(datapoint)
            #Clean the data strings
            mystring1 = mystring.replace("[", "")
            mystring2 = mystring1.replace("u'", "")
            mystring3 = mystring2.replace("]", "")
            mystring4 = mystring3.replace("'", "")
            #Write the data to the file
        myfile.write(mystring4 + "," + playerdata + "," + teamname + "," + position + "," + selected + form + "," + str(price) + ',' + str(i) + "\n")
    except:
            #Write all of the numbers for which there was errors to a file
            # print "it didnt work"
            errfile = open("errfile.txt", "a")
            errfile.write(str(i) + "\n")
            pass
    print i
    i += 1
print "Player data scraped"
##############################
