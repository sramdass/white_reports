class AddTimeToSecTestMaps < ActiveRecord::Migration
  def self.up
    add_column :sec_test_maps, :startdate, :date
    add_column :sec_test_maps, :enddate, :date
    add_column :sec_test_maps, :event_id, :integer
  end

  def self.down
    remove_column :sec_test_maps, :event_id
    remove_column :sec_test_maps, :enddate
    remove_column :sec_test_maps, :startdate
  end
end
