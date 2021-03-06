class WeatherController < ApplicationController
  
  layout proc{ |c| c.request.xhr? ? false : "weather_layout" }
  
  
  def index
    if params[:fahrenheit]
      @standard = true
    end
    if @standard
      @temp_upper = 88
      @wind_upper = 88
      @rain_upper = 0.5
    else
      @temp_upper = 30
      @wind_upper = 25
      @rain_upper = 12
    end
    @record = Records.find(:first,:order => "timestamp DESC").converted(@standard)
    @columns = [:timestamp , :record_num , :air_temp_c_avg , :air_temp_c_max , :air_temp_c_min , :rel_hum_avg , :rel_hum_max , :rel_hum_min , :wind_speed_ms_max , :wind_speed_avg , :wind_dir_avg , :solar_rad_w_avg , :solar_rad_w_max , :rain_mm_total , :dew_point_c_max , :dew_point_c_min , :wind_chill_c_max , :wind_chill_c_min , :heat_index_c_max , :heat_index_c_min , :etrs_mm_total , :rso]
    @graph = open_flash_chart_object(600,300, '/weather/weather/today_temp', true, '/weather/')     
    @last = Records.last_x_hours(24)
    @last_24 =[]
    @last.each do |record|
      @last_24 << record.converted(@standard)
    end
    @last = Records.last_x_hours(6)
    @last_6 = []
    @last.each do |record|
      @last_6 << record.converted(@standard)
    end
    @sunrise = Suns.find(:first ,  :conditions => ["suns.rise >= ? and suns.set <= ?",Time.now.strftime("%Y-%m-%d 00:00:01 %Z"),Time.now.hence(1.day).strftime("%Y-%m-%d 00:00:01 %Z")])
    @dst = Daylights.dst?(@record.timestamp)
    if @sunrise
      if @dst
        @sunrise.rise = @sunrise.rise.hence(1.hours)
        @sunrise.set = @sunrise.set.hence(1.hours)
      end 
    end
  end
  
  def get_data
   
    if params[:search][:start_date] && params[:search][:start_date].length >0
      @start_date = params[:search][:start_date].to_datetime
    end
    if params[:search][:end_date] && params[:search][:end_date].length >0
      @end_date = params[:search][:end_date].to_datetime
    end
      
    if @start_date && @end_date
      @records = Records.find(:all,:order => "timestamp ASC",:conditions => ["timestamp >= ? AND timestamp <= ?",@start_date.strftime("%Y-%m-%d 00:00:00 %Z"),@end_date.strftime("%Y-%m-%d 00:00:00 %Z")])
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename='+Date.today.strftime+'.csv'
      headers['Cache-Control'] = ''
      render :layout => false 
    else
      flash[:notice] = "You must fill out both date fields"
      redirect_to :action => :index
    end
  end
  
  def current_weather
    @record = Records.find(:first,:order => "timestamp DESC")
    respond_to do |format|
      format.xml  {  render :template => "weather/current_weather" , :layout => false}
    end
  end
  
  def day_temp
    @description = Description.find_by_name(__method__.to_s.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_temp/24', true, '/weather/') 
    session[:foo => @description.name]    
    render :template => "weather/graph"
  end
  
  def two_day_temp
    @description = Description.find_by_name(__method__.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_temp/48', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def two_day_solar
    @description = Description.find_by_name(__method__.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_solar/48', true, '/weather/')     
    render :template => "weather/graph"
  end    
  
  def day_solar
    @description = Description.find_by_name(__method__.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_solar/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def two_day_solar_max
    @description = Description.find_by_name(__method__.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_solar_max/48', true, '/weather/')     
    render :template => "weather/graph"
  end    
  
  def day_solar_max
    @description = Description.find_by_name(__method__.to_s)
    @graph = open_flash_chart_object(600,300, '/weather/graph_solar_max/24', true, '/weather/')     
    render :template => "weather/graph"
  end
  
  def graph_temp
    hours = params[:hours].to_i
    last = Records.last_x_hours(hours)
  
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
    hours = params[:hours].to_i
    last = Records.last_x_hours(hours)
    max_y = ((last.max {|a,b| a.rso <=> b.rso}).rso*1150).divmod(100)[0]*100
  
    g = Graph.new
    g.set_swf_path('/weather/')
    g.set_js_path("/weather/javascripts/")

    g.title( 'Solar Radiation Average actual vs predicted', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.solar_rad_w_avg*3.6})
    g.line_dot( 2, 4, '#818D9D', 'Actual Radiation in watts/m² converted to kilojoules/m²', 10 )
    g.set_data(last.collect {|record|record.rso*1000})
    g.line_hollow( 2, 4, '#164166', 'Predicted Radiation in kilojoules/m²', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(max_y)
    g.set_y_right_max(max_y)
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
  
  def graph_solar_max
    hours = params[:hours].to_i
    last = Records.last_x_hours(hours)
    max_y = ((last.max {|a,b| a.rso <=> b.rso}).rso*1150).divmod(100)[0]*100
  
    g = Graph.new
    g.set_swf_path('/weather/')
    g.set_js_path("/weather/javascripts/")

    g.title( 'Solar Radiation Maximum actual vs predicted', '{color: #7E97A6; font-size: 20; text-align: center}' )
    g.set_bg_color('#FFFFFF')
    g.set_data(last.collect {|record|record.solar_rad_w_max*3.6})
    g.line_dot( 2, 4, '#818D9D', 'Max Radiation in watts/m² converted to kilojoules/m²', 10 )
    g.set_data(last.collect {|record|record.rso*1000})
    g.line_hollow( 2, 4, '#164166', 'Predicted Radiation in kilojoules/m²', 10 )
    g.attach_to_y_right_axis(2)
    g.set_y_max(max_y)
    g.set_y_right_max(max_y)
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
