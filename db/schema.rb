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

ActiveRecord::Schema.define(version: 20180317035334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "abouts", id: :serial, force: :cascade do |t|
    t.string "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
  end

  create_table "cards", id: :serial, force: :cascade do |t|
    t.string "cardId", null: false
    t.string "type", null: false
    t.integer "cost"
    t.string "playerClass"
    t.string "rarity", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "formats", default: "standard", null: false
    t.integer "player_id"
    t.boolean "craft", default: true
    t.integer "usable", default: 0
    t.integer "multi_class_id"
    t.string "multiClassGroup"
    t.integer "race_id"
    t.integer "attack"
    t.integer "health"
    t.string "mechanics", array: true
    t.string "race_name"
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
    t.string "dbfid", default: "", null: false
    t.index ["collection_id"], name: "index_cards_on_collection_id"
    t.index ["multi_class_id"], name: "index_cards_on_multi_class_id"
    t.index ["player_id"], name: "index_cards_on_player_id"
    t.index ["race_id"], name: "index_cards_on_race_id"
  end

  create_table "checks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "deck_id", null: false
    t.integer "success", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dust", default: 0
    t.index ["deck_id"], name: "index_checks_on_deck_id"
    t.index ["user_id"], name: "index_checks_on_user_id"
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "formats", default: "standard", null: false
    t.boolean "adventure", default: false
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
  end

  create_table "decks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "playerClass", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.text "caption"
    t.string "formats", default: "standard", null: false
    t.string "author"
    t.integer "price", default: 0
    t.integer "player_id"
    t.integer "power", default: 1
    t.integer "style_id"
    t.boolean "reno_type", default: false
    t.string "slug"
    t.text "caption_en"
    t.integer "race_id"
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
    t.index ["player_id"], name: "index_decks_on_player_id"
    t.index ["race_id"], name: "index_decks_on_race_id"
    t.index ["slug"], name: "index_decks_on_slug", unique: true
    t.index ["style_id"], name: "index_decks_on_style_id"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "exchanges", id: :serial, force: :cascade do |t|
    t.integer "position_id"
    t.integer "card_id"
    t.integer "priority"
    t.integer "max_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_exchanges_on_card_id"
    t.index ["position_id"], name: "index_exchanges_on_position_id"
  end

  create_table "fixes", id: :serial, force: :cascade do |t|
    t.string "body_en", null: false
    t.string "body_ru", null: false
    t.integer "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_id"], name: "index_fixes_on_about_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "lines", id: :serial, force: :cascade do |t|
    t.integer "deck_id", null: false
    t.integer "card_id", null: false
    t.integer "max_amount", null: false
    t.integer "priority", null: false
    t.integer "min_mana"
    t.integer "max_mana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_lines_on_card_id"
    t.index ["deck_id"], name: "index_lines_on_deck_id"
  end

  create_table "mulligans", id: :serial, force: :cascade do |t|
    t.integer "deck_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_mulligans_on_deck_id"
    t.index ["player_id"], name: "index_mulligans_on_player_id"
  end

  create_table "multi_classes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
  end

  create_table "news", id: :serial, force: :cascade do |t|
    t.string "url_label", null: false
    t.string "label", null: false
    t.string "caption", null: false
    t.string "image", default: "news-default-image.jpg", null: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "multi_class_id"
    t.boolean "playable", default: true
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
    t.index ["multi_class_id"], name: "index_players_on_multi_class_id"
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.integer "amount", null: false
    t.integer "positionable_id"
    t.string "positionable_type"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "caption"
    t.boolean "must_have", default: false
    t.index ["card_id"], name: "index_positions_on_card_id"
    t.index ["positionable_id", "positionable_type"], name: "index_positions_on_positionable_id_and_positionable_type"
  end

  create_table "races", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
  end

  create_table "shifts", id: :serial, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "change_id", null: false
    t.integer "priority", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "caption_en"
    t.string "caption_ru"
    t.index ["card_id"], name: "index_shifts_on_card_id"
    t.index ["change_id"], name: "index_shifts_on_change_id"
  end

  create_table "styles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "name", default: {"en"=>"", "ru"=>""}, null: false
  end

  create_table "substitutions", id: :serial, force: :cascade do |t|
    t.integer "check_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_id"], name: "index_substitutions_on_check_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.string "username", default: "", null: false
    t.boolean "get_news", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
