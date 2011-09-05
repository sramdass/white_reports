class AddAuthTokenToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :auth_token, :string
  end

  def self.down
    remove_column :profiles, :auth_token
  end
end
