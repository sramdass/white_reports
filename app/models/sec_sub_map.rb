# == Schema Information
#
# Table name: sec_sub_maps
#
#  id          :integer         not null, primary key
#  section_id  :integer
#  subject_id  :integer
#  teacher_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  mark_column :integer
#  max_marks   :float
#  pass_marks  :float
#

class SecSubMap < ActiveRecord::Base
	belongs_to :section
	belongs_to :subject
	belongs_to :teacher
	
	scope :by_section_id, lambda { |id| where(:section_id => id)}
	scope :by_subject_id, lambda { |id| where(:subject_id => id)}
	scope :by_teacher_id, lambda { |id| where(:teacher_id => id)}
end
