web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec rake jobs:work
scrape_players: python scrape_files/players.py
scrape_gameweeks: python scrape_files/player_gameweek_data.py
scrape_season_totals: python scrape_files/player_season_totals.py
