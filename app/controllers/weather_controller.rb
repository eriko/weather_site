class WeatherController < ApplicationController
  
  layout "weather_layout"
  
  def index
    @record = Records.find(:first,:order => "timestamp DESC")
    @columns = [:timestamp , :record_num , :air_temp_c_avg , :air_temp_c_max , :air_temp_c_min , :rel_hum_avg , :rel_hum_max , :rel_hum_min , :wind_speed_ms_max , :wind_speed_avg , :wind_dir_avg , :solar_rad_w_avg , :solar_rad_w_max , :rain_mm_total , :dew_point_c_max , :dew_point_c_min , :wind_chill_c_max , :wind_chill_c_min , :heat_index_c_max , :heat_index_c_min , :etrs_mm_total , :rso]
    @graph = open_flash_chart_object(600,300, '/weather/weather/today', true, '/weather')     
    @last_24 = Records.last_24_hours
  end
  
  def today
    last_24 = Records.last_24_hours
    end_time = Time.now
    begin_time = Time.mktime(end_time.year,end_time.month,end_time.day,end_time.hour)-(86400) 
  
    g = Graph.new
    g.set_swf_path('/weather/')
    g.set_js_path("/weather/javascripts/")

    g.title( 'Temperature', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last_24.collect {|record|record.air_temp_c_avg})
    g.line_dot( 2, 4, '#818D9D', 'Temp in C', 10 )
    g.set_data(last_24.collect {|record|record.solar_rad_w_avg})
    g.line_hollow( 2, 4, '#164166', 'W/m2', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(50)
    g.set_y_right_max(1200)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.y_right_axis_color('#164166' )
    g.set_x_legend( 'TESC Weather Station', 12, '#164166' )
    g.set_y_legend( 'Average Air Temp C', 12, '#164166' )
    g.set_y_legend_right( 'Solar Radiation hourly average W/m2' ,12 , '#164166' )
    tmp = []
    24.times do |time|
      tmp << (begin_time + (time * 3600)).strftime("%H:%M")
    end
    g.set_x_labels(tmp)
    g.set_x_label_style(10, '#164166', 0, 3, '#818D9D' )
    g.set_y_label_steps(5)
  
    render :text => g.render
  end
  
  

end
