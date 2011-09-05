# == Schema Information
#
# Table name: students
#
#  id         :integer         not null, primary key
#  section_id :integer
#  name       :string(255)
#  id_no      :string(255)
#  female     :boolean
#  dob        :date
#  created_at :datetime
#  updated_at :datetime
#

class Student < ActiveRecord::Base
	
	belongs_to :section
	
	has_one :student_contact, :dependent => :destroy
	accepts_nested_attributes_for :student_contact
	
	validates	:name,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 50}
                   		
	validates	:id_no,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 15}
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end   
	
end
