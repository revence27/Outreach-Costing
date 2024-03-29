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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120225164518) do

  create_table "activities", :force => true do |t|
    t.text     "name"
    t.integer  "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_items", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "associated_items", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "activity_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assumptions", :force => true do |t|
    t.text     "name"
    t.text     "category",                          :null => false
    t.text     "section",                           :null => false
    t.text     "label"
    t.text     "units"
    t.float    "value",            :default => 0.0, :null => false
    t.integer  "activity_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "congregations", :force => true do |t|
    t.text     "name"
    t.integer  "health_unit_id"
    t.integer  "populated_location_id"
    t.text     "populated_location_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.text     "name",       :default => "Uganda", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "district_data", :force => true do |t|
    t.integer  "populated_location_id"
    t.string   "populated_location_type"
    t.integer  "population"
    t.integer  "under_one"
    t.integer  "one_to_four"
    t.integer  "pregnancies"
    t.integer  "number_sub_counties"
    t.integer  "number_parishes"
    t.integer  "number_venues"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "health_sub_districts", :force => true do |t|
    t.text     "name"
    t.integer  "district_id"
    t.integer  "populated_location_id"
    t.string   "populated_location_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "health_units", :force => true do |t|
    t.text     "name"
    t.integer  "code"
    t.text     "owner"
    t.text     "level"
    t.text     "status"
    t.integer  "parish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_assumptions", :force => true do |t|
    t.text     "name"
    t.text     "category",                            :null => false
    t.text     "section",                             :null => false
    t.text     "label"
    t.text     "units"
    t.float    "value",              :default => 0.0, :null => false
    t.integer  "associated_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.text     "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parishes", :force => true do |t|
    t.text     "name",          :null => false
    t.integer  "sub_county_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_counties", :force => true do |t|
    t.text     "name",                   :null => false
    t.integer  "health_sub_district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tranches", :force => true do |t|
    t.text     "name"
    t.text     "category"
    t.integer  "assumption_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "username",                      :null => false
    t.text     "sha1_pass",                     :null => false
    t.text     "sha1_salt",                     :null => false
    t.boolean  "is_admin",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", :force => true do |t|
    t.text     "name",        :null => false
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "villages", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "parish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
