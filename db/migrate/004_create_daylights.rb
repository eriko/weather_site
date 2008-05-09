class CreateDaylights < ActiveRecord::Migration
  def self.up
    create_table :daylights do |t|
      t.column :start , :timestamp
      t.column :stop , :timestamp
      
    end
  end

  def self.down
    drop_table :daylights
  end
end
