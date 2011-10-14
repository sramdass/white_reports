class AddPassMarksToSecSubMaps < ActiveRecord::Migration
  def self.up
    add_column :sec_sub_maps, :pass_marks, :float
  end

  def self.down
    remove_column :sec_sub_maps, :pass_marks
  end
end
