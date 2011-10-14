class AddMaxMarksToSecSubMaps < ActiveRecord::Migration
  def self.up
    add_column :sec_sub_maps, :max_marks, :float
  end

  def self.down
    remove_column :sec_sub_maps, :max_marks
  end
end
