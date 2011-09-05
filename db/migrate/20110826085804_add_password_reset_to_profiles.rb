class AddPasswordResetToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :password_reset_token, :string
    add_column :profiles, :password_reset_sent_at, :datetime
  end

  def self.down
    remove_column :profiles, :password_reset_sent_at
    remove_column :profiles, :password_reset_token
  end
end
