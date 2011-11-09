# == Schema Information
#
# Table name: clazzs
#
#  id         :integer         not null, primary key
#  branch_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Clazz < ActiveRecord::Base
	
#-------ASSOCIATIONS------------#	
	belongs_to :branch
  	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :branch		
	
	has_many :sections, :dependent => :destroy
	accepts_nested_attributes_for :sections, :reject_if => :has_only_destroy?, :allow_destroy => true
	
#-------VALIDATIONS------------#

	 validates 	:name, 	:presence => true, 
                       					:length => {:maximum => 30}
                       					
#-------- INSTANCE MODULES --------#                      					
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end       
	
	#Returns true if there is only "_destroy" attribute available for nested models.
	def has_only_destroy?(attrs)
	    attrs.each do |k,v|
	    	if k !="_destroy" && !v.blank?
	    		return false
	    	end
		end
		return true	
  	end	
  		
end
