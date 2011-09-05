# == Schema Information
#
# Table name: subjects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  branch_id  :integer
#

class Subject < ActiveRecord::Base
	
	belongs_to :school
	
	has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
	has_many :sections, :through => :sec_sub_maps

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
