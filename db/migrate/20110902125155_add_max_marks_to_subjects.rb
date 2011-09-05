class AddMaxMarksToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :max_marks, :float
  end

  def self.down
    remove_column :subjects, :max_marks
  end
end
