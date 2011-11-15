class AddRecurringDescriptionToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :recurring, :integer
    add_column :events, :description, :string
  end

  def self.down
    remove_column :events, :description
    remove_column :events, :recurring
  end
end
