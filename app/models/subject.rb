# == Schema Information
#
# Table name: subjects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  branch_id  :integer
#  max_marks  :float
#

class Subject < ActiveRecord::Base

#-------ASSOCIATIONS------------#		
	belongs_to :branch
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :branch	
	
	has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
	has_many :sections, :through => :sec_sub_maps
	
	
	scope :by_section, lambda { |section_id| 
		joins(:sec_sub_maps).where('sec_sub_maps.section_id = ?', section_id)
	}
	
#-------VALIDATIONS------------#	

	validates	:name,  	:presence => true, 
                   						:length => {:minimum => 1, :maximum => 30}
	validates 	:max_marks, 	:presence => true, 
												:numericality => { :greater_than_or_equal_to  => 0 }         
	
#-------- INSTANCE MODULES --------#	   		
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end   

end
