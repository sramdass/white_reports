class CreateTimeTables < ActiveRecord::Migration
  def self.up
    create_table :time_tables do |t|
      t.integer :section_id
      t.integer :period_no
      t.integer :monday
      t.integer :tuesday
      t.integer :wednesday
      t.integer :thursday
      t.integer :friday
      t.integer :saturday
      t.integer :sunday

      t.timestamps
    end
  end

  def self.down
    drop_table :time_tables
  end
end
