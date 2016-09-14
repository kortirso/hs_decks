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

ActiveRecord::Schema.define(version: 20160914135239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string   "cardId",                             null: false
    t.string   "name_en",                            null: false
    t.string   "type",                               null: false
    t.integer  "cost"
    t.string   "playerClass"
    t.string   "rarity",                             null: false
    t.integer  "collection_id",                      null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "formats",       default: "standard", null: false
    t.string   "image_en"
    t.string   "name_ru"
    t.string   "image_ru"
    t.integer  "player_id"
    t.boolean  "craft",         default: true
    t.index ["collection_id"], name: "index_cards_on_collection_id", using: :btree
    t.index ["player_id"], name: "index_cards_on_player_id", using: :btree
  end

  create_table "checks", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "deck_id",                null: false
    t.integer  "success",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "dust",       default: 0
    t.index ["deck_id"], name: "index_checks_on_deck_id", using: :btree
    t.index ["user_id"], name: "index_checks_on_user_id", using: :btree
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name_en",                         null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "formats",    default: "standard", null: false
    t.string   "name_ru"
    t.boolean  "adventure",  default: false
  end

  create_table "decks", force: :cascade do |t|
    t.string   "name",                             null: false
    t.integer  "user_id",                          null: false
    t.string   "playerClass",                      null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "link"
    t.text     "caption"
    t.string   "formats",     default: "standard", null: false
    t.string   "author"
    t.integer  "price",       default: 0
    t.integer  "player_id"
    t.integer  "power",       default: 1
    t.index ["player_id"], name: "index_decks_on_player_id", using: :btree
    t.index ["user_id"], name: "index_decks_on_user_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.integer  "amount",            null: false
    t.integer  "positionable_id"
    t.string   "positionable_type"
    t.integer  "card_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "caption"
    t.index ["card_id"], name: "index_positions_on_card_id", using: :btree
    t.index ["positionable_id", "positionable_type"], name: "index_positions_on_positionable_id_and_positionable_type", using: :btree
  end

  create_table "shifts", force: :cascade do |t|
    t.integer  "card_id",    null: false
    t.integer  "change_id",  null: false
    t.integer  "priority",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "caption_en"
    t.string   "caption_ru"
    t.index ["card_id"], name: "index_shifts_on_card_id", using: :btree
    t.index ["change_id"], name: "index_shifts_on_change_id", using: :btree
  end

  create_table "substitutions", force: :cascade do |t|
    t.integer  "check_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_id"], name: "index_substitutions_on_check_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "role",                   default: "user"
    t.string   "username",               default: "",     null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
