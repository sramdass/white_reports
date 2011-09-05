class CreateTeacherContacts < ActiveRecord::Migration
  def self.up
    create_table :teacher_contacts do |t|
      t.integer :teacher_id
      t.string :primary_email
      t.string :email
      t.string :mobile
      t.string :telephone
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :teacher_contacts
  end
end
