class Mark < ActiveRecord::Base
	
	#-------ASSOCIATIONS------------#		
	belongs_to :section
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :section		
	
	belongs_to :student
end
