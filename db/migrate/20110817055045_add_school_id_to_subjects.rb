class AddSchoolIdToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :school_id, :integer
  end

  def self.down
    remove_column :subjects, :school_id
  end
end
