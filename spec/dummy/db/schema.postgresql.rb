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

ActiveRecord::Schema.define(version: 2022_04_17_063406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "gera_cbr_external_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate", null: false
    t.float "original_rate", null: false
    t.integer "nominal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cur_from", "cur_to", "date"], name: "index_cbr_external_rates_on_cur_from_and_cur_to_and_date", unique: true
  end

  create_table "gera_cross_rate_modes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "currency_rate_mode_id", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.uuid "rate_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_rate_mode_id"], name: "index_cross_rate_modes_on_currency_rate_mode_id"
    t.index ["rate_source_id"], name: "index_cross_rate_modes_on_rate_source_id"
  end

  create_table "gera_currency_rate_history_intervals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "cur_from_iso_code", limit: 2, null: false
    t.integer "cur_to_iso_code", limit: 2, null: false
    t.float "min_rate", null: false
    t.float "avg_rate", null: false
    t.float "max_rate", null: false
    t.datetime "interval_from", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "interval_to", null: false
    t.index ["cur_from_iso_code", "cur_to_iso_code", "interval_from"], name: "crhi_unique_index", unique: true
    t.index ["interval_from"], name: "index_currency_rate_history_intervals_on_interval_from"
  end

  create_table "gera_currency_rate_mode_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.string "title"
    t.text "details"
    t.index ["status"], name: "index_currency_rate_mode_snapshots_on_status"
    t.index ["title"], name: "index_currency_rate_mode_snapshots_on_title", unique: true
  end

  create_table "gera_currency_rate_modes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.integer "mode", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "currency_rate_mode_snapshot_id", null: false
    t.string "cross_currency1"
    t.uuid "cross_rate_source1_id"
    t.string "cross_currency2"
    t.string "cross_currency3"
    t.uuid "cross_rate_source2_id"
    t.uuid "cross_rate_source3_id"
    t.index ["cross_rate_source1_id"], name: "index_currency_rate_modes_on_cross_rate_source1_id"
    t.index ["cross_rate_source2_id"], name: "index_currency_rate_modes_on_cross_rate_source2_id"
    t.index ["cross_rate_source3_id"], name: "index_currency_rate_modes_on_cross_rate_source3_id"
    t.index ["currency_rate_mode_snapshot_id", "cur_from", "cur_to"], name: "crm_id_pair", unique: true
  end

  create_table "gera_currency_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "currency_rate_mode_snapshot_id", null: false
    t.index ["currency_rate_mode_snapshot_id"], name: "fk_rails_456167e2a9"
  end

  create_table "gera_currency_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate_value", null: false
    t.uuid "snapshot_id", null: false
    t.json "metadata", null: false
    t.datetime "created_at"
    t.uuid "external_rate_id"
    t.integer "mode", null: false
    t.uuid "rate_source_id"
    t.uuid "external_rate1_id"
    t.uuid "external_rate2_id"
    t.uuid "external_rate3_id"
    t.index ["created_at", "cur_from", "cur_to"], name: "currency_rates_created_at"
    t.index ["external_rate1_id"], name: "index_currency_rates_on_external_rate1_id"
    t.index ["external_rate2_id"], name: "index_currency_rates_on_external_rate2_id"
    t.index ["external_rate3_id"], name: "index_currency_rates_on_external_rate3_id"
    t.index ["external_rate_id"], name: "fk_rails_905ddd038e"
    t.index ["rate_source_id"], name: "fk_rails_2397c780d5"
    t.index ["snapshot_id", "cur_from", "cur_to"], name: "index_current_exchange_rates_uniq", unique: true
  end

  create_table "gera_direction_rate_history_intervals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "min_rate", null: false
    t.float "max_rate", null: false
    t.float "min_comission", null: false
    t.float "max_comission", null: false
    t.datetime "interval_from", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "interval_to", null: false
    t.uuid "payment_system_to_id", null: false
    t.uuid "payment_system_from_id", null: false
    t.float "avg_rate", null: false
    t.index ["interval_from", "payment_system_from_id", "payment_system_to_id"], name: "drhi_uniq", unique: true
    t.index ["payment_system_from_id"], name: "fk_rails_70f35124fc"
    t.index ["payment_system_to_id"], name: "fk_rails_5c92dd1b7f"
  end

  create_table "gera_direction_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "gera_direction_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ps_from_id", null: false
    t.uuid "ps_to_id", null: false
    t.uuid "currency_rate_id", null: false
    t.float "rate_value", null: false
    t.float "base_rate_value", null: false
    t.float "rate_percent", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "exchange_rate_id", null: false
    t.boolean "is_used", default: false, null: false
    t.uuid "snapshot_id"
    t.index ["created_at", "ps_from_id", "ps_to_id"], name: "direction_rates_created_at"
    t.index ["currency_rate_id"], name: "fk_rails_d6f1847478"
    t.index ["exchange_rate_id", "id"], name: "index_direction_rates_on_exchange_rate_id_and_id"
    t.index ["ps_from_id", "ps_to_id", "id"], name: "index_direction_rates_on_ps_from_id_and_ps_to_id_and_id"
    t.index ["ps_to_id"], name: "fk_rails_fbaf7f33e1"
    t.index ["snapshot_id"], name: "fk_rails_392aafe0ef"
  end

  create_table "gera_exchange_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "income_payment_system_id", null: false
    t.string "in_cur", limit: 6, null: false
    t.string "out_cur", limit: 6, null: false
    t.uuid "outcome_payment_system_id", null: false
    t.float "value", null: false
    t.boolean "is_enabled", default: false, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["income_payment_system_id", "outcome_payment_system_id"], name: "exchange_rate_unique_index", unique: true
    t.index ["is_enabled"], name: "index_exchange_rates_on_is_enabled"
    t.index ["outcome_payment_system_id"], name: "fk_rails_ef77ea3609"
  end

  create_table "gera_external_rate_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "rate_source_id", null: false
    t.datetime "actual_for", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.index ["rate_source_id", "actual_for"], name: "index_external_rate_snapshots_on_rate_source_id_and_actual_for", unique: true
    t.index ["rate_source_id"], name: "index_external_rate_snapshots_on_rate_source_id"
  end

  create_table "gera_external_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id", null: false
    t.string "cur_from", null: false
    t.string "cur_to", null: false
    t.float "rate_value"
    t.uuid "snapshot_id", null: false
    t.datetime "created_at"
    t.index ["snapshot_id", "cur_from", "cur_to"], name: "index_external_rates_on_snapshot_id_and_cur_from_and_cur_to", unique: true
    t.index ["source_id"], name: "index_external_rates_on_source_id"
  end

  create_table "gera_payment_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 60
    t.integer "priority", limit: 2
    t.string "currency_iso_code", null: false
    t.boolean "income_enabled", default: false, null: false
    t.boolean "outcome_enabled", default: false, null: false
    t.datetime "archived_at"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "is_available", default: true, null: false
    t.string "icon"
    t.float "commission", default: 0.0, null: false
    t.decimal "minimal_income_amount_cents", default: "0.0", null: false
    t.decimal "maximal_income_amount_cents", default: "1000.0", null: false
    t.decimal "minimal_outcome_amount_cents", default: "1.0", null: false
    t.decimal "maximal_outcome_amount_cents", default: "1000.0", null: false
    t.boolean "require_verify", default: false, null: false
    t.boolean "require_phone_on_income", default: false, null: false
    t.boolean "require_phone_on_outcome", default: false, null: false
    t.boolean "require_telegram_on_income", default: false, null: false
    t.boolean "require_telegram_on_outcome", default: false, null: false
    t.index ["income_enabled"], name: "index_payment_systems_on_income_enabled"
    t.index ["outcome_enabled"], name: "index_payment_systems_on_outcome_enabled"
  end

  create_table "gera_rate_sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key", null: false
    t.uuid "actual_snapshot_id"
    t.integer "priority", default: 0, null: false
    t.boolean "is_enabled", default: true, null: false
    t.jsonb "supported_tickers", default: [], null: false
    t.datetime "supported_tickers_updated_at"
    t.index ["actual_snapshot_id"], name: "fk_rails_0b6cf3ddaa"
    t.index ["key"], name: "index_rate_sources_on_key", unique: true
    t.index ["title"], name: "index_rate_sources_on_title", unique: true
  end

  add_foreign_key "gera_cross_rate_modes", "gera_currency_rate_modes", column: "currency_rate_mode_id", on_delete: :cascade
  add_foreign_key "gera_cross_rate_modes", "gera_rate_sources", column: "rate_source_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_currency_rate_mode_snapshots", column: "currency_rate_mode_snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source1_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source2_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_modes", "gera_rate_sources", column: "cross_rate_source3_id", on_delete: :cascade
  add_foreign_key "gera_currency_rate_snapshots", "gera_currency_rate_mode_snapshots", column: "currency_rate_mode_snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_currency_rate_snapshots", column: "snapshot_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate1_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate2_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate3_id", on_delete: :cascade
  add_foreign_key "gera_currency_rates", "gera_external_rates", column: "external_rate_id", on_delete: :nullify
  add_foreign_key "gera_currency_rates", "gera_rate_sources", column: "rate_source_id", on_delete: :cascade
  add_foreign_key "gera_direction_rate_history_intervals", "gera_payment_systems", column: "payment_system_from_id", on_delete: :cascade
  add_foreign_key "gera_direction_rate_history_intervals", "gera_payment_systems", column: "payment_system_to_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_currency_rates", column: "currency_rate_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_exchange_rates", column: "exchange_rate_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_payment_systems", column: "ps_from_id", on_delete: :cascade
  add_foreign_key "gera_direction_rates", "gera_payment_systems", column: "ps_to_id", on_delete: :cascade
  add_foreign_key "gera_exchange_rates", "gera_payment_systems", column: "income_payment_system_id", on_delete: :cascade
  add_foreign_key "gera_exchange_rates", "gera_payment_systems", column: "outcome_payment_system_id", on_delete: :cascade
  add_foreign_key "gera_external_rates", "gera_external_rate_snapshots", column: "snapshot_id", on_delete: :cascade
  add_foreign_key "gera_external_rates", "gera_rate_sources", column: "source_id", on_delete: :cascade
end
