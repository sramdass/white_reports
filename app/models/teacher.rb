# == Schema Information
#
# Table name: teachers
#
#  id         :integer         not null, primary key
#  id_no      :string(255)
#  name       :string(255)
#  female     :boolean
#  created_at :datetime
#  updated_at :datetime
#  branch_id  :integer
#

class Teacher < ActiveRecord::Base
	belongs_to :branch
	
	has_one :teacher_contact, :dependent => :destroy
	accepts_nested_attributes_for :teacher_contact
	
	validates	:name,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 50}
                   		
	validates	:id_no,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 15}
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end     

end
