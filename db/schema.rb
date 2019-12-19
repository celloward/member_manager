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

ActiveRecord::Schema.define(version: 2019_12_19_180705) do

  create_table "leaderships", force: :cascade do |t|
    t.integer "leader_id"
    t.integer "ministry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_leaderships_on_leader_id"
    t.index ["ministry_id"], name: "index_leaderships_on_ministry_id"
  end

  create_table "marriages", force: :cascade do |t|
    t.integer "husband_id"
    t.integer "wife_id"
    t.string "marriage_date"
    t.string "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["husband_id"], name: "index_marriages_on_husband_id"
    t.index ["wife_id"], name: "index_marriages_on_wife_id"
  end

  create_table "ministries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "street_address"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.integer "parent_id"
    t.boolean "member", default: false, null: false
    t.string "date_of_death"
    t.index ["parent_id"], name: "index_people_on_parent_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
