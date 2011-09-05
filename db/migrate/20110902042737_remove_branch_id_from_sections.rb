class RemoveBranchIdFromSections < ActiveRecord::Migration
  def self.up
  	remove_column :sections, :branch_id
  end

  def self.down
  end
end
