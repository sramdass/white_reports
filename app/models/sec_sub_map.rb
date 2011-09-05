# == Schema Information
#
# Table name: sec_sub_maps
#
#  id         :integer         not null, primary key
#  section_id :integer
#  subject_id :integer
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class SecSubMap < ActiveRecord::Base
	belongs_to :section
	belongs_to :subject
end
