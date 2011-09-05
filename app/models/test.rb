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
	belongs_to :branch
		
	validates	:name,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 30}
	
	def self.search(search)
		if search
			where('name LIKE ?', "%#{search}%")
		else
			scoped
		end
	end   
		
end
