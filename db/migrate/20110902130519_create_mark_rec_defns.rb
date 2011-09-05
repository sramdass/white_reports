class CreateMarkRecDefns < ActiveRecord::Migration
  def self.up
    create_table :mark_rec_defns do |t|
      t.string :name
      t.string :subject_id_list
      t.integer :hash_value

      t.timestamps
    end
  end

  def self.down
    drop_table :mark_rec_defns
  end
end
