# FantasyOffside [ ![Codeship Status for mariann013/FantasyOffside](https://codeship.com/projects/dcb279c0-87bd-0133-f070-36a0203442ba/status?branch=master)](https://codeship.com/projects/123015)

![alt tag](https://github.com/mariann013/FantasyOffside/blob/master/public/img/logo.png)

* Mari-Ann Meling - mariann013
* Rob Stevenson - thisdotrob
* Mateja Popovic - mateja683
* Ivan Sathianathan - ivan-sathianathan

## Application Description
Have you ever had the problem of waking up on a Saturday morning, maybe slightly worse for wear, and the deadline for your fantasy football predictions is looming ahead? We have. Wouldn't it be nice if there was an application that would tell us what players to transfer and play? Here it is - Fantasy Offside!

Helping you pick the best premiership fantasy football team - Fantasy Offside allows you to input your Fantasy Premiership Id number and returns your current squad, hit optimise team and you'll be presented with a starting 11, substitutes, captian, vice-captain and most of all the player that you should transfer out and their replacement.

## The Techy Stuff
Fantasy Offside was built by using python scripts to scrape the player data from the Fantasy Premiership website and then inputted into our PostGresQL database. 
We then created our own Rails API and ruby logic to retrive the JSON data of the user's squad and run our algorythm against the players currently in the squad. 
To present the information to the user we used AngularJS styled with Bootstrap. 

##Instalation Instructions
 
 - Clone the repository
 - Run bundle install
 - In psql createdb FantasyOffsie_development and FantasyOffside_test
 - Run rake db:auto-migrate
 - Run bin/rails s in command line


