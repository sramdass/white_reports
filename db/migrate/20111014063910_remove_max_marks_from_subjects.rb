class RemoveMaxMarksFromSubjects < ActiveRecord::Migration
  def self.up
    remove_column :subjects, :max_marks
  end

  def self.down
    add_column :subjects, :max_marks, :float
  end
end
