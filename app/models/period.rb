class Period < ActiveRecord::Base
	belongs_to :branch
  	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :branch
	
	validates :period_no, 	:numericality => true, 
											:length => { :maximum => 12, :minimum => 1 },
											:uniqueness => true
	
	validate :starttime_should_be_less_than_endtime			
	
	scope :for_branch, lambda { |branch| where("branch_id = ?", branch.id).order("period_no")	}
		
	def starttime_should_be_less_than_endtime
		if starttime > endtime
			errors.add(:endtime, "should be later than start time")
		end
	end																

end
