class Records < ActiveRecord::Base
  
    def Records.last_x_hours(hours)
    Records.find(:all,:order => "timestamp ASC",:conditions => ["timestamp >= ? AND timestamp <= ?",Time.now.ago(hours,:hours).strftime("%Y-%m-%d %I:%M:%S %Z"),Time.now.strftime("%Y-%m-%d %I:%M:%S %Z")])
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