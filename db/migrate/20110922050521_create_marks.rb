class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.integer :section_id
      t.integer :test_id
      t.integer :student_id
      t.float :english
      t.float :maths
      t.float :science
      t.float :tamil

      t.timestamps
    end
  end

  def self.down
    drop_table :marks
  end
end
