class CreateClazzs < ActiveRecord::Migration
  def self.up
    create_table :clazzs do |t|
      t.integer :branch_id
      t.string :name
      t.integer :class_teacher_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clazzs
  end
end
