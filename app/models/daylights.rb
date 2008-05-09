class Daylights < ActiveRecord::Base
  
 def Daylights.dst?(time = Time.now)
  Daylights.find(:first,:conditions => ["daylights.start < ? AND daylights.stop > ?",time.strftime("%Y-%m-%d 00:00:01 %Z"),time.strftime("%Y-%m-%d 00:00:01 %Z")])
end
  
end
