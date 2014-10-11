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

ActiveRecord::Schema.define(version: 20130828085610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_versions", force: true do |t|
    t.integer  "character_id"
    t.integer  "version"
    t.text     "csv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_versions", ["character_id", "version"], name: "character_versions_character_id_version_key", unique: true, using: :btree
  add_index "character_versions", ["id", "character_id"], name: "character_versions_id_character_id_key", unique: true, using: :btree

  create_table "characters", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",          limit: 510
    t.string   "slug",          limit: 510,                 null: false
    t.integer  "bgg_thread_id"
    t.text     "description"
    t.string   "status",        limit: 20,  default: "WIP", null: false
  end

  add_index "characters", ["id", "user_id"], name: "characters_id_user_id_key", unique: true, using: :btree
  add_index "characters", ["name", "user_id"], name: "characters_name_user_id_key", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",           limit: 510, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 80
    t.string   "scope",          limit: 510
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "friendly_id_slugs_slug_sluggable_type_scope_key", unique: true, using: :btree

  create_table "official_characters", force: true do |t|
    t.string   "name",               limit: 510
    t.string   "profession",         limit: 510
    t.string   "age",                limit: 510
    t.integer  "number"
    t.string   "set",                limit: 510
    t.string   "setting",            limit: 510
    t.string   "circle",             limit: 510
    t.string   "nature",             limit: 510
    t.integer  "speed"
    t.integer  "health"
    t.integer  "wits"
    t.integer  "melee"
    t.integer  "power"
    t.integer  "damage"
    t.integer  "aim"
    t.integer  "point"
    t.integer  "throw"
    t.integer  "react"
    t.integer  "stealth"
    t.integer  "armor"
    t.integer  "strength"
    t.integer  "intellect"
    t.integer  "honor"
    t.integer  "respect"
    t.integer  "range_opfire"
    t.integer  "range_power"
    t.integer  "range_max"
    t.integer  "range_min"
    t.string   "area",               limit: 510
    t.integer  "range_damage"
    t.integer  "common_cards"
    t.integer  "secret_cards"
    t.integer  "elite_cards"
    t.integer  "henchmen"
    t.string   "standard_abilities", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "official_specials", force: true do |t|
    t.integer  "official_character_id"
    t.text     "description"
    t.integer  "survival"
    t.integer  "ranged"
    t.integer  "melee"
    t.integer  "adventure"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 510
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 510
    t.string   "context",       limit: 256
    t.datetime "created_at"
  end

  create_table "tags", force: true do |t|
    t.string "name", limit: 510
  end

  create_table "users", force: true do |t|
    t.string   "email",                  limit: 510, default: "", null: false
    t.string   "encrypted_password",     limit: 510, default: "", null: false
    t.string   "reset_password_token",   limit: 510
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 510
    t.string   "last_sign_in_ip",        limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 510
    t.string   "confirmation_token",     limit: 510
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 510
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token",           limit: 510
    t.datetime "locked_at"
    t.string   "slug",                   limit: 510,              null: false
  end

  add_index "users", ["confirmation_token"], name: "users_confirmation_token_key", unique: true, using: :btree
  add_index "users", ["email"], name: "users_email_key", unique: true, using: :btree
  add_index "users", ["name"], name: "users_name_key", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "users_reset_password_token_key", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "users_unlock_token_key", unique: true, using: :btree

end
