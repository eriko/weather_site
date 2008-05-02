class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
 t.column :timestamp, :datetime
    t.column :record_num, :integer
    t.column :air_temp_c_avg, :float
    t.column :air_temp_c_max, :float
    t.column :air_temp_c_min, :float
    t.column :rel_hum_avg, :float
    t.column :rel_hum_max, :float
    t.column :rel_hum_min, :float
    t.column :wind_speed_ms_max, :float
    t.column :wind_speed_avg, :float
    t.column :wind_dir_avg, :float
    t.column :solar_rad_w_avg, :float
    t.column :solar_rad_w_max, :float
    t.column :rain_mm_total, :float
    t.column :dew_point_c_max, :float
    t.column :dew_point_c_min, :float
    t.column :wind_chill_c_max, :float
    t.column :wind_chill_c_min, :float
    t.column :heat_index_c_max, :float
    t.column :heat_index_c_min, :float
    t.column :etrs_mm_total, :float
    t.column :rso, :float
      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
