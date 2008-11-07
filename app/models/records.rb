class Records < ActiveRecord::Base
  
    def Records.last_x_hours(hours)
      Records.find(:all,:order => "timestamp ASC",:conditions => ["timestamp >= ? AND timestamp <= ?",Time.now.ago(hours.hours).strftime("%Y-%m-%d %H:%M:%S %Z"),Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")])
  end
  
    def converted(convert)
      unless convert
        return self
      else
        converted = self.clone
        converted.air_temp_c_avg   = (air_temp_c_avg   * 1.8) + 32
        converted.air_temp_c_max   = (air_temp_c_max   * 1.8) + 32
        converted.air_temp_c_min   = (air_temp_c_min   * 1.8) + 32
        converted.dew_point_c_max  = (dew_point_c_max  * 1.8) + 32
        converted.dew_point_c_min  = (dew_point_c_min  * 1.8) + 32
        converted.wind_chill_c_max = (wind_chill_c_max * 1.8) + 32
        converted.wind_chill_c_min = (wind_chill_c_min * 1.8) + 32
        converted.heat_index_c_max = (heat_index_c_max * 1.8) + 32
        converted.heat_index_c_min = (heat_index_c_min * 1.8) + 32
        converted.wind_speed_ms_max = wind_speed_ms_max * 2.24
        converted.wind_speed_avg = wind_speed_avg * 2.24
        converted.etrs_mm_total = etrs_mm_total * 0.04
        converted.rain_mm_total = rain_mm_total * 0.04
        converted
      end
    end
  
end

require "fastercsv"

class ActiveRecord::Base
  def self.to_csv(*args)
    find(:all).to_csv(*args)
  end
  
  def export_columns(format = nil)
    self.class.content_columns.map(&:name) - ['created_at', 'updated_at']
  end
  
  def to_row(format = nil)
    export_columns(format).map { |c| self.send(c) }
  end
end

class Array
  def to_csv(options = {})
    if all? { |e| e.respond_to?(:to_row) }
      header_row = first.export_columns(options[:format]).to_csv
      content_rows = map { |e| e.to_row(options[:format]) }.map(&:to_csv)
      ([header_row] + content_rows).join
    else
      FasterCSV.generate_line(self, options)
    end
  end
end