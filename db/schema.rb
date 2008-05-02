# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "pg_ts_cfg", :id => false, :force => true do |t|
    t.text "ts_name",  :null => false
    t.text "prs_name", :null => false
    t.text "locale"
  end

  create_table "pg_ts_cfgmap", :id => false, :force => true do |t|
    t.text   "ts_name",                  :null => false
    t.text   "tok_alias",                :null => false
    t.string "dict_name", :limit => nil
  end

# Could not dump table "pg_ts_dict" because of following StandardError
#   Unknown type 'regprocedure' for column 'dict_init'

# Could not dump table "pg_ts_parser" because of following StandardError
#   Unknown type 'regprocedure' for column 'prs_start'

  create_table "records", :force => true do |t|
    t.datetime "timestamp"
    t.integer  "record_num"
    t.float    "air_temp_c_avg"
    t.float    "air_temp_c_max"
    t.float    "air_temp_c_min"
    t.float    "rel_hum_avg"
    t.float    "rel_hum_max"
    t.float    "rel_hum_min"
    t.float    "wind_speed_ms_max"
    t.float    "wind_speed_avg"
    t.float    "wind_dir_avg"
    t.float    "solar_rad_w_avg"
    t.float    "solar_rad_w_max"
    t.float    "rain_mm_total"
    t.float    "dew_point_c_max"
    t.float    "dew_point_c_min"
    t.float    "wind_chill_c_max"
    t.float    "wind_chill_c_min"
    t.float    "heat_index_c_max"
    t.float    "heat_index_c_min"
    t.float    "etrs_mm_total"
    t.float    "rso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
