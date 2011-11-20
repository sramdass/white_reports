class TimeTable < ActiveRecord::Base
	belongs_to :section
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :section		
	
	scope :for_section, lambda { |section| where(:section_id => section.id).order("period_no")}
	scope :for_section_id, lambda { |id| where(:section_id => id).order("period_no")}	
	scope :for_period_no, lambda { |pno| where(:period_no => pno)}
		
	def self.section_day_periods(section, day)
		periods = TimeTable.for_section(section).find(:all, :select => "period_no, #{day.downcase}")
		hash=Hash.new
		periods.each do |p|
			hash[p.period_no] = p.send(day)
		end
		return hash
	end
	
end
