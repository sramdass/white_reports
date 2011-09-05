class RemoveTypeFromClass < ActiveRecord::Migration
  def self.up
  	remove_column :schools, :type
  end

  def self.down
  end
end
