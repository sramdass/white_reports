class AddRecurringWindowToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :recurring_end, :date
  end

  def self.down
    remove_column :events, :recurring_end
  end
end
