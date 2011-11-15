class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :attendee_id
      t.string :attendee_type
      t.integer :event_id
      t.integer :response

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
