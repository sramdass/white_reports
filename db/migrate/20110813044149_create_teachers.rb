class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.integer :school_id
      t.string :id_no
      t.string :name
      t.boolean :female

      t.timestamps
    end
  end

  def self.down
    drop_table :teachers
  end
end
