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

  add_index "character_versions", ["character_id", "version"], name: "index_character_versions_on_character_id_and_version", unique: true, using: :btree
  add_index "character_versions", ["character_id"], name: "index_character_versions_on_character_id", using: :btree
  add_index "character_versions", ["id", "character_id"], name: "index_character_versions_on_id_and_character_id", unique: true, using: :btree

  create_table "characters", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "slug",                                     null: false
    t.integer  "bgg_thread_id"
    t.text     "description"
    t.string   "status",        limit: 10, default: "WIP", null: false
  end

  add_index "characters", ["id", "user_id"], name: "index_characters_on_id_and_user_id", unique: true, using: :btree
  add_index "characters", ["name", "user_id"], name: "index_characters_on_name_and_user_id", unique: true, using: :btree
  add_index "characters", ["name"], name: "index_characters_on_name", using: :btree
  add_index "characters", ["slug"], name: "index_characters_on_slug", using: :btree
  add_index "characters", ["status", "id"], name: "index_characters_on_status_and_id", using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "official_characters", force: true do |t|
    t.string   "name"
    t.string   "profession"
    t.string   "age"
    t.integer  "number"
    t.string   "set"
    t.string   "setting"
    t.string   "circle"
    t.string   "nature"
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
    t.string   "area"
    t.integer  "range_damage"
    t.integer  "common_cards"
    t.integer  "secret_cards"
    t.integer  "elite_cards"
    t.integer  "henchmen"
    t.string   "standard_abilities"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "official_characters", ["name"], name: "index_official_characters_on_name", using: :btree
  add_index "official_characters", ["number"], name: "index_official_characters_on_number", using: :btree

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

  add_index "official_specials", ["official_character_id"], name: "index_official_specials_on_official_character_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "slug",                                null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
