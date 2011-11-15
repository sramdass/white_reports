# == Schema Information
#
# Table name: branches
#
#  id             :integer         not null, primary key
#  institution_id :integer
#  name           :string(255)
#  id_no          :string(255)
#  principal      :string(255)
#  address        :string(255)
#  city           :string(255)
#  state          :string(255)
#  pin            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  tipe           :string(255)
#

class Branch < ActiveRecord::Base
	
#-------ASSOCIATIONS------------#
	belongs_to :institution
  	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :institution		
	
	has_many :clazzs, :dependent => :destroy
	accepts_nested_attributes_for :clazzs, :reject_if => :has_only_destroy?, :allow_destroy => true
	
	has_many :teachers, :dependent => :destroy
	accepts_nested_attributes_for :teachers, :reject_if => :has_only_destroy?, :allow_destroy => true
		
	has_many :subjects, :dependent => :destroy
	accepts_nested_attributes_for :subjects, :reject_if => :has_only_destroy?,  :allow_destroy => true
	
	has_many :tests, :dependent => :destroy
	accepts_nested_attributes_for :tests, :reject_if => :has_only_destroy?,  :allow_destroy => true
	
	has_many :schedules, :as => :attendee, :dependent => :destroy #polymorphic assocation. 'resource' can be teacher, section or school etc..
	has_many :events, :through => :schedules	#for many to many relationship. 	
	
#-------VALIDATIONS------------#
	 validates 	:name, 	:presence => true, 
                       					:length => {:maximum => 50}
                       					
	 validates 	:id_no, :tipe, :city, :state,		:presence => true, 
                       													:length => {:maximum => 20}
	validates :id_no, :uniqueness => true
	                      													
	 validates 	:pin, 	:presence => true, 
                       				:length => {:in => 6..7}             	
	
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
