# == Schema Information
#
# Table name: student_contacts
#
#  id            :integer         not null, primary key
#  student_id    :integer
#  primary_email :string(255)
#  email         :string(255)
#  mobile        :string(255)
#  telephone     :string(255)
#  address       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class StudentContact < ActiveRecord::Base
#-------ASSOCIATIONS------------#		
	belongs_to :student
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :student
	
#-------VALIDATIONS------------#
	
  	validates :primary_email,	:presence => true,   
            										:uniqueness => true,   
            										:format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }  
	validates 	:email, :mobile, :telephone,		:length => {:maximum => 50}
	validates 	:address,	:length => {:maximum => 500}	
end
