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

ActiveRecord::Schema.define(version: 20150620185636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.string   "url"
    t.datetime "published_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "guid"
    t.text     "summary"
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "full_name"
    t.integer  "prediction_days"
    t.integer  "prediction_type"
    t.integer  "market_id"
    t.integer  "marketplace_id"
  end

  create_table "currencies_portfolios", force: :cascade do |t|
    t.integer  "currency_id"
    t.integer  "portfolio_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "custom_fanns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.float    "last"
    t.float    "high"
    t.float    "low"
    t.float    "volume",           default: 0.0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "subject"
    t.string   "ref_cr"
    t.boolean  "predicted",        default: false
    t.integer  "prediction_id"
    t.integer  "currency_id"
    t.integer  "market_id"
    t.datetime "time"
    t.date     "date"
    t.integer  "predictable_id"
    t.string   "predictable_type"
  end

  create_table "influences", force: :cascade do |t|
    t.integer  "knn_id"
    t.integer  "article_id"
    t.string   "classification"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "knns", force: :cascade do |t|
    t.integer  "currency_id"
    t.string   "keywords",    default: [],              array: true
    t.hstore   "cdata",       default: {}
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "marketplaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "markets", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "risk_free_rate", default: 0.0025
    t.integer  "supermarket_id"
  end

  create_table "neural_networks", force: :cascade do |t|
    t.integer  "epochs"
    t.integer  "hidden_layer_size"
    t.integer  "input_layer_size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "max_nr_of_days"
    t.integer  "predictable_id"
    t.string   "predictable_type"
  end

  create_table "portfolios", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.float    "p_return"
    t.float    "variance",   default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "max_return"
    t.hstore   "weights"
  end

end
