# == Schema Information
#
# Table name: tests
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  branch_id  :integer
#

class Test < ActiveRecord::Base

#-------ASSOCIATIONS------------#		
	belongs_to :branch
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :branch	
	
	has_many :sec_test_maps, :dependent => true, :dependent => :destroy
	has_many :sections, :through => :sec_test_maps	
	
	scope :by_section, lambda { |section_id| 
		joins(:sec_test_maps).where('sec_test_maps.section_id = ?', section_id)
	}	
	
#-------VALIDATIONS------------#		
		
	validates	:name,  	:presence => true, 
                   						:length => {:minimum => 1, :maximum => 30}
	

#-------- INSTANCE MODULES --------#	   	
	def self.search(search)
		if search
			where('name LIKE ?', "%#{search}%")
		else
			scoped
		end
	end   
		
end
