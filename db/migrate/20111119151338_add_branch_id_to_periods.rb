class AddBranchIdToPeriods < ActiveRecord::Migration
  def self.up
    add_column :periods, :branch_id, :integer
  end

  def self.down
    remove_column :periods, :branch_id
  end
end
