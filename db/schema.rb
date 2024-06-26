# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_18_043725) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "name"
    t.string "address"
    t.float "lat"
    t.float "lon"
    t.string "type_of_accommodation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "expenses"
    t.index ["trip_id"], name: "index_accommodations_on_trip_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "description"
    t.float "lat"
    t.float "lon"
    t.integer "expenses"
    t.float "rating"
    t.bigint "daily_itinerary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "time"
    t.index ["daily_itinerary_id"], name: "index_activities_on_daily_itinerary_id"
  end

  create_table "daily_itineraries", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_daily_itineraries_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "status", default: 0
    t.integer "total_budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.float "lat"
    t.float "lon"
  end

  add_foreign_key "accommodations", "trips"
  add_foreign_key "activities", "daily_itineraries"
  add_foreign_key "daily_itineraries", "trips"
end
