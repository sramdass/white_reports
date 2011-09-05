class AddPasswordDigestToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :password_digest, :string
  end

  def self.down
    remove_column :profiles, :password_digest
  end
end
