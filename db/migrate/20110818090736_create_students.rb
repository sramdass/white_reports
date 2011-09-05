class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :section_id
      t.string :name
      t.string :id_no
      t.boolean :female
      t.date :dob

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
