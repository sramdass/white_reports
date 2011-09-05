class CreateStudentContacts < ActiveRecord::Migration
  def self.up
    create_table :student_contacts do |t|
      t.integer :student_id
      t.string :primary_email
      t.string :email
      t.string :mobile
      t.string :telephone
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :student_contacts
  end
end
