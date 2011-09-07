class AddProfilePtrToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :profile_ptr, :integer
  end

  def self.down
    remove_column :profiles, :profile_ptr
  end
end
