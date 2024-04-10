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

ActiveRecord::Schema[7.1].define(version: 2024_04_10_050151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accomodations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "address"
    t.float "lat"
    t.float "lon"
    t.integer "type_of_accomodation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["trip_id"], name: "index_accomodations_on_trip_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "address"
    t.string "description"
    t.float "lat"
    t.float "lon"
    t.string "activity_type"
    t.integer "expenses"
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trip_id", null: false
    t.datetime "date_and_time"
    t.index ["trip_id"], name: "index_activities_on_trip_id"
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
  end

  add_foreign_key "accomodations", "trips"
  add_foreign_key "activities", "trips"
end
