class RemoveTypeFromBranches < ActiveRecord::Migration
  def self.up
  	remove_column :branches, :type
  end

  def self.down
  end
end
