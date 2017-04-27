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

ActiveRecord::Schema.define(version: 20170425182002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abouts", force: :cascade do |t|
    t.string   "version",    null: false
    t.string   "label_en",   null: false
    t.string   "label_ru",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string   "cardId",                               null: false
    t.string   "name_en",                              null: false
    t.string   "type",                                 null: false
    t.integer  "cost"
    t.string   "playerClass"
    t.string   "rarity",                               null: false
    t.integer  "collection_id",                        null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "formats",         default: "standard", null: false
    t.string   "name_ru"
    t.integer  "player_id"
    t.boolean  "craft",           default: true
    t.integer  "usable",          default: 0
    t.integer  "multi_class_id"
    t.string   "multiClassGroup"
    t.boolean  "hall_of_fame",    default: false
    t.integer  "race_id"
    t.integer  "attack"
    t.integer  "health"
    t.string   "mechanics",                                         array: true
    t.string   "race_name"
    t.index ["collection_id"], name: "index_cards_on_collection_id", using: :btree
    t.index ["multi_class_id"], name: "index_cards_on_multi_class_id", using: :btree
    t.index ["player_id"], name: "index_cards_on_player_id", using: :btree
    t.index ["race_id"], name: "index_cards_on_race_id", using: :btree
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
    t.integer  "style_id"
    t.boolean  "reno_type",   default: false
    t.string   "slug"
    t.string   "name_en"
    t.text     "caption_en"
    t.integer  "race_id"
    t.index ["player_id"], name: "index_decks_on_player_id", using: :btree
    t.index ["race_id"], name: "index_decks_on_race_id", using: :btree
    t.index ["slug"], name: "index_decks_on_slug", unique: true, using: :btree
    t.index ["style_id"], name: "index_decks_on_style_id", using: :btree
    t.index ["user_id"], name: "index_decks_on_user_id", using: :btree
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer  "position_id"
    t.integer  "card_id"
    t.integer  "priority"
    t.integer  "max_amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["card_id"], name: "index_exchanges_on_card_id", using: :btree
    t.index ["position_id"], name: "index_exchanges_on_position_id", using: :btree
  end

  create_table "fixes", force: :cascade do |t|
    t.string   "body_en",    null: false
    t.string   "body_ru",    null: false
    t.integer  "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_fixes_on_about_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "lines", force: :cascade do |t|
    t.integer  "deck_id",    null: false
    t.integer  "card_id",    null: false
    t.integer  "max_amount", null: false
    t.integer  "priority",   null: false
    t.integer  "min_mana"
    t.integer  "max_mana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_lines_on_card_id", using: :btree
    t.index ["deck_id"], name: "index_lines_on_deck_id", using: :btree
  end

  create_table "mulligans", force: :cascade do |t|
    t.integer  "deck_id"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_mulligans_on_deck_id", using: :btree
    t.index ["player_id"], name: "index_mulligans_on_player_id", using: :btree
  end

  create_table "multi_classes", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "url_label",                                     null: false
    t.string   "label",                                         null: false
    t.string   "caption",                                       null: false
    t.string   "image",      default: "news-default-image.jpg", null: false
    t.string   "link"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ru"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "multi_class_id"
    t.boolean  "playable",       default: true
    t.index ["multi_class_id"], name: "index_players_on_multi_class_id", using: :btree
  end

  create_table "positions", force: :cascade do |t|
    t.integer  "amount",                            null: false
    t.integer  "positionable_id"
    t.string   "positionable_type"
    t.integer  "card_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "caption"
    t.boolean  "must_have",         default: false
    t.index ["card_id"], name: "index_positions_on_card_id", using: :btree
    t.index ["positionable_id", "positionable_type"], name: "index_positions_on_positionable_id_and_positionable_type", using: :btree
  end

  create_table "races", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "styles", force: :cascade do |t|
    t.string   "name_en"
    t.string   "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean  "get_news",               default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
