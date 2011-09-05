class RemoveSchoolIds < ActiveRecord::Migration
  def self.up
  	remove_columns :sections, :school_id
  	remove_columns :teachers, :school_id
  	remove_columns :subjects, :school_id
  	remove_columns :tests, :school_id
  end

  def self.down
  end
end
