class AddProfileTypeToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :profile_type, :integer
  end

  def self.down
    remove_column :profiles, :profile_type
  end
end
