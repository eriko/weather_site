class WeatherController < ApplicationController
  
  
  
  def index
    @record = Records.find(:first,:order => "timestamp DESC")
     @columns = [:timestamp , :record_num , :air_temp_c_avg , :air_temp_c_max , :air_temp_c_min , :rel_hum_avg , :rel_hum_max , :rel_hum_min , :wind_speed_ms_max , :wind_speed_avg , :wind_dir_avg , :solar_rad_w_avg , :solar_rad_w_max , :rain_mm_total , :dew_point_c_max , :dew_point_c_min , :wind_chill_c_max , :wind_chill_c_min , :heat_index_c_max , :heat_index_c_min , :etrs_mm_total , :rso]

  end
end
