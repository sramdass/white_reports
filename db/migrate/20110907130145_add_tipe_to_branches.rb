class AddTipeToBranches < ActiveRecord::Migration
  def self.up
    add_column :branches, :tipe, :string
  end

  def self.down
    remove_column :branches, :tipe
  end
end
