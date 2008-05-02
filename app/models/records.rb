class Records < ActiveRecord::Base
  
  def Records.last_24_hours
    end_time = Time.now
    begin_time = Time.mktime(end_time.year,end_time.month,end_time.day,end_time.hour)-(86400)
    Records.find(:all,:conditions => ["timestamp >= ? AND timestamp <= ?",begin_time.strftime("%Y-%m-%d %I:%M:%S %Z"),end_time.strftime("%Y-%m-%d %I:%M:%S %Z")])
  end
  
end

