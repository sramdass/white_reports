class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.integer :school_id
      t.string :name
      t.integer :class_teacher_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
