class WeatherController < ApplicationController
  
  layout "weather_layout"
  
  def index
    @record = Records.find(:first,:order => "timestamp DESC")
    @columns = [:timestamp , :record_num , :air_temp_c_avg , :air_temp_c_max , :air_temp_c_min , :rel_hum_avg , :rel_hum_max , :rel_hum_min , :wind_speed_ms_max , :wind_speed_avg , :wind_dir_avg , :solar_rad_w_avg , :solar_rad_w_max , :rain_mm_total , :dew_point_c_max , :dew_point_c_min , :wind_chill_c_max , :wind_chill_c_min , :heat_index_c_max , :heat_index_c_min , :etrs_mm_total , :rso]
    @graph = open_flash_chart_object(600,300, '/weather/weather/today_temp', true, '/weather/')     
    @last_24 = Records.last_x_hours(24)
    @last_6 = Records.last_x_hours(6)
  end
  
  def get_data
   
    if params[:search][:start_date] && params[:search][:start_date].length >0
      @start_date = params[:search][:start_date].to_datetime
    end
    if params[:search][:end_date] && params[:search][:end_date].length >0
      @end_date = params[:search][:end_date].to_datetime
    end
      
    if @start_date && @end_date
      @records = Records.find(:all,:order => "timestamp ASC",:conditions => ["timestamp >= ? AND timestamp <= ?",@start_date.strftime("%Y-%m-%d %I:%M:%S %Z"),@end_date.strftime("%Y-%m-%d %I:%M:%S %Z")])
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename='+Date.today.strftime+'.xls"'
      headers['Cache-Control'] = ''
      render :layout => false 
    else
      flash[:notice] = "You must fill out both date fields"
      redirect_to :action => :index
    end
  end
  
  def day_temp
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_temp/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def two_day_temp
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_temp/48', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def two_day_solar
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_solar/48', true, '/weather/')     
    render :template => "weather/graph"
  end    
  
  def day_solar
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_solar/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def two_day_solar_max
    @graph = open_flash_chart_object(600,300, '/weather/weather/graph_solar/48', true, '/weather/')     
    render :template => "weather/graph"
  end    
  
  def day_solar_max
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

    g.title( 'Solar Radiation Average actual vs predicted', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.solar_rad_w_avg})
    g.line_dot( 2, 4, '#818D9D', 'Actual Radiation in watts/m2', 10 )
    g.set_data(last.collect {|record|record.rso})
    g.line_hollow( 2, 4, '#164166', 'Predicted Radiation in Megajoules/m²', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(3000)
    g.set_y_right_max(10)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.y_right_axis_color('#164166' )
    g.set_x_legend( 'TESC Weather Station', 12, '#164166' )
    g.set_y_legend( 'Actual Average', 12, '#164166' )
    g.set_y_legend_right( 'Predicted Average' ,12 , '#164166' )

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

    g.title( 'Solar Radiation Maximum actual vs predicted', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.solar_rad_w_max})
    g.line_dot( 2, 4, '#818D9D', 'Max Radiation in watts/m2', 10 )
    g.set_data(last.collect {|record|record.rso})
    g.line_hollow( 2, 4, '#164166', 'Predicted Radiation in Megajoules/m²', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(3000)
    g.set_y_right_max(10)
    g.set_x_axis_color('#818D9D', '#F0F0F0' )
    g.set_y_axis_color( '#818D9D', '#ADB5C7' )
    g.y_right_axis_color('#164166' )
    g.set_x_legend( 'TESC Weather Station', 12, '#164166' )
    g.set_y_legend( 'Actual Average', 12, '#164166' )
    g.set_y_legend_right( 'Predicted Average' ,12 , '#164166' )

    g.set_x_labels(last.collect {|record|record.timestamp.strftime("%H:%M")})
    g.set_x_label_style(10, '#164166', 0, 3, '#818D9D' )
    g.set_y_label_steps(5)
  
    render :text => g.render
  end
  
  
  

end
