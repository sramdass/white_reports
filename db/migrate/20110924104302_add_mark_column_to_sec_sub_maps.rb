class AddMarkColumnToSecSubMaps < ActiveRecord::Migration
  def self.up
    add_column :sec_sub_maps, :mark_column, :integer
  end

  def self.down
    remove_column :sec_sub_maps, :mark_column
  end
end
