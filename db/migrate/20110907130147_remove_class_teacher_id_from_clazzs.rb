class RemoveClassTeacherIdFromClazzs < ActiveRecord::Migration
  def self.up
  	remove_column :clazzs, :class_teacher_id
  end

  def self.down
  end
end
