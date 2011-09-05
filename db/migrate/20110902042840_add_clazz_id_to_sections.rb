class AddClazzIdToSections < ActiveRecord::Migration
  def self.up
  	add_column :sections, :clazz_id, :integer
  end

  def self.down
  	remove_column :sections, :clazz_id
  end
end
