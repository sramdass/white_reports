class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.integer :institution_id
      t.string :name
      t.string :id_no
      t.string :type
      t.string :principal
      t.string :address
      t.string :city
      t.string :state
      t.string :pin

      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
