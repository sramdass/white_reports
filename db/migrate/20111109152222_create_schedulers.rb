class CreateSchedulers < ActiveRecord::Migration
  def self.up
    create_table :schedulers do |t|
      t.string :resource_id
      t.integer :resource_type
      t.integer :event_id
      t.integer :response

      t.timestamps
    end
  end

  def self.down
    drop_table :schedulers
  end
end
