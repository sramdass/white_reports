class CreateInstitutions < ActiveRecord::Migration
  def self.up
    create_table :institutions do |t|
      t.string :name
      t.string :ceo
      t.string :id_no
      t.string :registered_address
      t.string :city
      t.string :state
      t.string :pin

      t.timestamps
    end
  end

  def self.down
    drop_table :institutions
  end
end
