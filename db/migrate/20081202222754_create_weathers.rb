class CreateWeathers < ActiveRecord::Migration
  def self.up
    create_table :weathers do |t|
      t.datetime :recorded_datetime
      t.float :it
      t.float :ot
      t.float :hot
      t.float :lot
      t.float :oh
      t.float :ih
      t.float :dp
      t.float :wc
      t.float :bp
      t.float :ws
      t.float :hws
      t.float :wd
      t.float :r
      t.timestamps
    end
  end

  def self.down
    drop_table :weathers
  end
end
