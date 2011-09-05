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
	has_many :branches, :dependent => :destroy
	accepts_nested_attributes_for :branches
	
	 validates 	:name,  :presence => true, 
                       	:length => {:minimum => 1, :maximum => 50}
                       	
	#-------- INSTANCE MODULES --------#
    def self.search(search)
		if search
			where('name LIKE ?', "%#{search}%")
		else
			scoped
		end
	end
	                       		
end
