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

ActiveRecord::Schema.define(version: 20160309023018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "home_team_id", null: false
    t.integer  "away_team_id", null: false
    t.integer  "round_id",     null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "region"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
  add_index "games", ["round_id"], name: "index_games_on_round_id", using: :btree

  create_table "picks", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id",    null: false
    t.integer  "points",     null: false
    t.integer  "round_id",   null: false
  end

  add_index "picks", ["user_id"], name: "index_picks_on_user_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "picks_start", null: false
    t.datetime "picks_end",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "team_round_results", force: :cascade do |t|
    t.integer  "team_id",    null: false
    t.integer  "round_id",   null: false
    t.boolean  "win",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "team_round_results", ["team_id", "round_id"], name: "index_team_round_results_on_team_id_and_round_id", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "seed",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "team_name"
    t.string   "password_digest"
    t.string   "session_token"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name",                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
