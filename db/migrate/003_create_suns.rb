class CreateSuns < ActiveRecord::Migration
  def self.up
    create_table :suns do |t|
      t.column :rise ,:timestamp
      t.column :set , :timestamp

    end
  end

  def self.down
    drop_table :suns
  end
end
