# == Schema Information
#
# Table name: institutions
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  ceo                :string(255)
#  id_no              :string(255)
#  registered_address :string(255)
#  city               :string(255)
#  state              :string(255)
#  pin                :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Institution < ActiveRecord::Base
	
#-------ASSOCIATIONS------------#	
	has_many :branches, :dependent => :destroy
	accepts_nested_attributes_for :branches,:reject_if => :has_only_destroy?, :allow_destroy => true

#-------VALIDATIONS------------#	
	 validates 	:name, 	:presence => true, 
                       					:length => {:maximum => 50}
	 validates 	:id_no, :city, :state,	:presence => true, 
                       										:length => {:maximum => 20}
    validates :id_no, :uniqueness => true
	validates :pin, 	:presence => true, 
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
