# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100121205753) do

  create_table "fs_checkins", :force => true do |t|
    t.integer  "fs_id",         :null => false
    t.integer  "fs_venue_id"
    t.string   "shout"
    t.datetime "checked_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fs_checkins", ["checked_in_at"], :name => "index_fs_checkins_on_checked_in_at"
  add_index "fs_checkins", ["fs_id"], :name => "index_fs_checkins_on_fs_id"
  add_index "fs_checkins", ["fs_venue_id", "checked_in_at"], :name => "index_fs_checkins_on_fs_venue_id_and_checked_in_at"

  create_table "fs_venues", :force => true do |t|
    t.integer  "fs_id",                                       :null => false
    t.string   "name"
    t.string   "address"
    t.string   "crossstreet"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.decimal  "geolat",      :precision => 15, :scale => 10
    t.decimal  "geolong",     :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fs_venues", ["fs_id"], :name => "index_fs_venues_on_fs_id"
  add_index "fs_venues", ["name"], :name => "index_fs_venues_on_name"

end
