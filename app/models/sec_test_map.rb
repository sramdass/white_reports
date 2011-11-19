# == Schema Information
#
# Table name: sec_test_maps
#
#  id         :integer         not null, primary key
#  section_id :integer
#  test_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class SecTestMap < ActiveRecord::Base
	belongs_to :section
	belongs_to :test
	
	belongs_to :event, :dependent => :destroy

	#When uncheck a particular subject form a section edit page, the corresponding row of the sec_test_maps will be 
	#deleted automatically because of the association 'section has_many sec_test_maps'. During that we need to make 
	#sure that the corresponding event gets deleted.	
	
	before_destroy :delete_event
	after_destroy :delete_event
		
	def delete_event
		debugger
		event = Event.find(self.event_id)
		if event
			event.destroy
		end
	end
	
end
