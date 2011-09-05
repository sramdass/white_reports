class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :type
      t.string :name
      t.string :location
      t.string :principal

      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
