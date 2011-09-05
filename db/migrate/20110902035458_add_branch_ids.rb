class AddBranchIds < ActiveRecord::Migration
  def self.up
  	add_column :sections, :branch_id, :integer
  	add_column :teachers, :branch_id, :integer
  	add_column :subjects, :branch_id, :integer
  	add_column :tests, :branch_id, :integer
  end

  def self.down
  	 remove_columns :sections, :branch_id
  	remove_columns :teachers, :branch_id
  	remove_columns :subjects, :branch_id
  	remove_columns :tests, :branch_id
  end
end
