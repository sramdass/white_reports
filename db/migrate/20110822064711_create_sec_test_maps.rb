class CreateSecTestMaps < ActiveRecord::Migration
  def self.up
    create_table :sec_test_maps do |t|
      t.integer :section_id
      t.integer :test_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sec_test_maps
  end
end
