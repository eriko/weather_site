class CreateSolars < ActiveRecord::Migration
  def self.up
    create_table :solars do |t|
      t.datetime :starttime
      t.datetime :endtime
      t.float :watts_sqr_meter
      t.integer :duration_ms

      t.timestamps
    end
  end

  def self.down
    drop_table :solars
  end
end
