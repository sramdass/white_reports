class CreateSecSubMaps < ActiveRecord::Migration
  def self.up
    create_table :sec_sub_maps do |t|
      t.integer :section_id
      t.integer :subject_id
      t.integer :teacher_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sec_sub_maps
  end
end
