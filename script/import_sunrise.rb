#!/usr/bin/env ruby
require 'rubygems'
require 'fastercsv'
require "parsedate"
require 'active_record'
require 'facets'

database_type = ARGV[2]

kind = ARGV[1]

if database_type.nil?
  database_type = 'development'
end

database_yaml = IO.read('config/database.yml')
class Suns < ActiveRecord::Base; set_table_name :suns; 

end
class Daylights < ActiveRecord::Base; set_table_name :daylights; 

end

databases = YAML::load(database_yaml)
ActiveRecord::Base.establish_connection(databases[database_type])

def get_data_sun(file)
  data = FasterCSV.open(file,  
    :headers => true,
    :converters => [
      lambda { |f, info| info.header == "timestamp"         ? Time.local(*ParseDate.parsedate(f,true)[0..2]) : f },
      lambda { |f, info| info.header == "record_num"        ? f.to_i : f },
      lambda { |f, info| info.header == "air_temp_c_avg"    ? f.to_f : f },
    
    ]
  )
  rise_reg = /([0-9])([0-9][0-9])/
  set_reg = /([0-9][0-9])([0-9][0-9])/
  data.each do |row|
    row.each do |col|
      #puts col.to_s
    end
    date = *ParseDate.parsedate(row['day'], true)
    rise_time = rise_reg.match(row['rise'])
    set_time = set_reg.match(row['set'])
    rise = Time.local(date[0],date[1],date[2]    ,rise_time[1],rise_time[2]    )
    set = Time.local(date[0],date[1],date[2]    ,set_time[1],set_time[2]    )
    puts "sunrise #{rise.to_s} and sunset #{set.to_s}"
    sun = Suns.new(:rise =>rise , :set => set)
  puts sun.rise
  sun.save
  end
  

end

def get_data_daylights(file)
  puts "Doing Daylights saving times values"
  data = FasterCSV.open(file,  
    :headers => true,
    :converters => [
      lambda { |f, info| info.header == "start_year"        ? f.to_i : f },
      lambda { |f, info| info.header == "start_month"       ? f.to_i : f },
      lambda { |f, info| info.header == "start_day"         ? f.to_i : f },
      lambda { |f, info| info.header == "end_year"          ? f.to_i : f },
      lambda { |f, info| info.header == "end_month"         ? f.to_i : f },
      lambda { |f, info| info.header == "end_day"           ? f.to_i : f }
    ]
  )

  data.each do |row|
puts row
    start = Time.local(row['start_year'],row['start_month'],row['start_day'] )
    stop = Time.local(row['end_year'],row['end_month'],row['end_day']    )
    puts "start #{start.to_s} and stop #{stop.to_s}"
    daylight = Daylights.new(:start =>start , :stop => stop)
  puts daylight.start
  daylight.save
  end
  

end

puts kind
if kind == 'sun'
 get_data_sun(ARGV[0])
elsif kind == 'daylight'
 get_data_daylights(ARGV[0])
end