class WeathersController < ApplicationController
  # GET /weathers
  # GET /weathers.xml
    layout proc{ |c| c.request.xhr? ? false : "weather_layout" }
  def index
    #@weathers = Weather.find(:all)
    @newest = Weather.find(:first,:order => "recorded_datetime DESC")
    @oldest = Weather.find(:first,:order => "recorded_datetime ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weathers }
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
       @records = Weather.find(:all,:order => "recorded_datetime ASC",:conditions => ["recorded_datetime >= ? AND recorded_datetime <= ?",@start_date.strftime("%Y-%m-%d 00:00:00 %Z"),@end_date.strftime("%Y-%m-%d 00:00:00 %Z")])
       
       csv_string = FasterCSV.generate do |csv|
         # header row
         csv << ["recorded_datetime" , "it " , "ot " , "hot" , "lot" , "oh " , "ih " , "dp " , "wc " , "bp " , "ws " , "hws" , "wd " , "r"]
         @records.each do |record|
           csv << [record[:recorded_datetime],record[:it],record[:ot] ,record[:hot],record[:lot],record[:oh] ,record[:ih] ,record[:dp] ,record[:wc] ,record[:bp] ,record[:ws] ,record[:hws],record[:wd],record[:r] ]
         end
       end
       send_data csv_string,
                 :type => 'text/csv; charset=iso-8859-1; header=present',
                 :disposition => "attachment; filename=weather_data-#{@start_date.strftime("%Y%m%d")}-#{@end_date.strftime("%Y%m%d")}.csv"
     else
       flash[:notice] = "You must fill out both date fields"
       redirect_to :action => :index
     end
   end
   


end
