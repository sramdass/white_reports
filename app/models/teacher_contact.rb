# == Schema Information
#
# Table name: teacher_contacts
#
#  id            :integer         not null, primary key
#  teacher_id    :integer
#  primary_email :string(255)
#  email         :string(255)
#  mobile        :string(255)
#  telephone     :string(255)
#  address       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class TeacherContact < ActiveRecord::Base
	belongs_to :teacher
end
