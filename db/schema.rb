# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151217160658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fixtures", force: :cascade do |t|
    t.integer "game_week"
    t.integer "opponent_id"
    t.boolean "is_home"
    t.integer "team_id"
  end

  add_index "fixtures", ["team_id"], name: "index_fixtures_on_team_id", using: :btree

  create_table "player_gameweek_totals", force: :cascade do |t|
    t.integer "playerid"
    t.integer "gameweek"
    t.integer "minutes_played"
    t.integer "goals_scored"
    t.integer "assists"
    t.integer "clean_sheets"
    t.integer "goals_conceded"
    t.integer "own_goals"
    t.integer "penalties_saved"
    t.integer "penalties_missed"
    t.integer "yellow_cards"
    t.integer "red_cards"
    t.integer "saves"
    t.integer "bonus_points"
    t.integer "total_points"
  end

  create_table "player_season_totals", force: :cascade do |t|
    t.integer "goals_scored"
    t.integer "goals_assisted"
    t.integer "clean_sheets"
    t.integer "goals_conceded"
    t.integer "own_goals"
    t.integer "yellow_cards"
    t.integer "red_cards"
    t.integer "minutes_played"
  end

  create_table "players", force: :cascade do |t|
    t.string  "playerdata"
    t.integer "teamid"
    t.string  "position"
    t.integer "price"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "fixtures", "teams"
end
