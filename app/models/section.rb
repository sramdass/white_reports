# == Schema Information
#
# Table name: sections
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  class_teacher_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  clazz_id         :integer
#

class Section < ActiveRecord::Base
	
#-------ASSOCIATIONS------------#	
	belongs_to :clazz
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :clazz	
	
	has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
	has_many :subjects, :through => :sec_sub_maps
	
	has_many :sec_test_maps, :dependent => true, :dependent => :destroy
	has_many :tests, :through => :sec_test_maps
	
	has_many :students, :dependent => :destroy
	accepts_nested_attributes_for :students, :reject_if => :has_only_destroy?, :allow_destroy => true
	
	has_many :marks, :dependent => :destroy
	accepts_nested_attributes_for :marks, :reject_if => :has_only_destroy?, :allow_destroy => true	

#-------VALIDATIONS------------#
	
	validates	:name,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 20}
                   		
	validates 	:class_teacher_id, :numericality => true
	
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
