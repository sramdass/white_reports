class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.integer :section_id
      t.integer :test_id
      t.integer :student_id
      t.float :sub1
      t.float :sub2
      t.float :sub3
      t.float :sub4
      t.float :sub5
      t.float :sub6
      t.float :sub7
      t.float :sub8
      t.float :sub9
      t.float :sub10
      t.float :sub11
      t.float :sub12
      t.float :sub13
      t.float :sub14
      t.float :sub15
      t.float :total
      t.integer :rank
      t.string :grade
      t.string :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :marks
  end
end
