class CreatePeriods < ActiveRecord::Migration
  def self.up
    create_table :periods do |t|
      t.integer :period_no
      t.time :starttime
      t.time :endtime

      t.timestamps
    end
  end

  def self.down
    drop_table :periods
  end
end
