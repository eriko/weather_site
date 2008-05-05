class WeatherController < ApplicationController
  
  layout "weather_layout"
  
  def index
    @record = Records.find(:first,:order => "timestamp DESC")
    @columns = [:timestamp , :record_num , :air_temp_c_avg , :air_temp_c_max , :air_temp_c_min , :rel_hum_avg , :rel_hum_max , :rel_hum_min , :wind_speed_ms_max , :wind_speed_avg , :wind_dir_avg , :solar_rad_w_avg , :solar_rad_w_max , :rain_mm_total , :dew_point_c_max , :dew_point_c_min , :wind_chill_c_max , :wind_chill_c_min , :heat_index_c_max , :heat_index_c_min , :etrs_mm_total , :rso]
    @graph = open_flash_chart_object(600,300, '/weather/weather/today_temp', true, '/weather/')     
    @last_24 = Records.last_x_hours(24)
    @last_6 = Records.last_x_hours(6)
  end
  
  def day_temp
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_temp/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def week_temp
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_temp/168', true, '/weather/')     
    render :template => "weather/graph"
  end
  
    def week_solar
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_solar/168', true, '/weather/')     
    render :template => "weather/graph"
  end    
  
    def day_solar
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_solar/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def graph_temp
    puts params

    hours = params[:id].to_i
    last = Records.last_x_hours(hours)
    end_time = Time.now
    begin_time = Time.mktime(end_time.year,end_time.month,end_time.day,end_time.hour)-(hours*3600) 
  
    g = Graph.new
    g.set_swf_path('/weather/')
    g.set_js_path("/weather/javascripts/")

    g.title( 'Temperature', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.air_temp_c_avg})
    g.line_dot( 2, 4, '#818D9D', 'Temp in C', 10 )
    g.set_y_max(40)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.set_x_legend( 'TESC Weather Station', 12, '#164166' )
    g.set_y_legend( 'Average Air Temp C', 12, '#164166' )

    g.set_x_labels(last.collect {|record|record.timestamp.strftime("%H:%M")})
    g.set_x_label_style(10, '#164166', 0, 3, '#818D9D' )
    g.set_y_label_steps(5)
  
    render :text => g.render
  end
  
    def graph_solar
    puts params

    hours = params[:id].to_i
    last = Records.last_x_hours(hours)
    end_time = Time.now
    begin_time = Time.mktime(end_time.year,end_time.month,end_time.day,end_time.hour)-(hours*3600) 
  
    g = Graph.new
    g.set_swf_path('/weather/')
    g.set_js_path("/weather/javascripts/")

    g.title( 'Solar Radiation', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.solar_rad_w_avg})
    g.line_dot( 2, 4, '#818D9D', 'Radiation in wm2', 10 )
    g.set_y_max(4000)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.set_x_legend( 'TESC Weather Station', 12, '#164166' )
    g.set_y_legend( 'Solar Radiation Average', 12, '#164166' )

    g.set_x_labels(last.collect {|record|record.timestamp.strftime("%H:%M")})
    g.set_x_label_style(10, '#164166', 0, 3, '#818D9D' )
    g.set_y_label_steps(5)
  
    render :text => g.render
  end
  
  
  

end
