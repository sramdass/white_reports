class AddArrearsToMarks < ActiveRecord::Migration
  def self.up
    add_column :marks, :arrears, :integer
  end

  def self.down
    remove_column :marks, :arrears
  end
end
