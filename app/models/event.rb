# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  startime    :datetime
#  endtime     :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  recurring   :integer
#  description :string(255)
#
=begin

This is relationship between the events and various resources.
Refer: http://blog.hasmanythrough.com/2006/4/3/polymorphic-through 
			http://stackoverflow.com/questions/5886738/setting-up-a-polymorphic-has-many-through-relationship
class Scheduler < ActiveRecord::Base
  belongs_to :event
  belongs_to :resource, :polymorphic => true
end

class Event < ActiveRecord::Base
  has_many :schedulers
  has_many :resources, :through => :schedulers
end

class Teacher < ActiveRecord::Base
  has_many :schedulers, :as => :resource
  has_many :events, :through => :schedulers
end

class Section < ActiveRecord::Base
  has_many :schedulers, :as => :resource
  has_many :events, :through => :schedulers
end

=end

class Event < ActiveRecord::Base
	
	RECURRING_EVERY_YEAR=0
	RECURRING_EVERY_MONTH=1
	RECURRING_EVERY_WEEK=2	
	RECURRING_EVERY_DAY=3
	RECURRING_EVERY_WEEK_DAY=4
	NOT_RECURRING = -1	
	
	scope :for_object, lambda { |object| joins(:schedules).where('schedules.attendee_type = ? and schedules.attendee_id = ?', object.class.to_s, object.id)}	
	
	#Note that this does not work for events spanning across multiple days. The events will appear only on the starting and the ending dates. Needs correction!
	scope :on_day, lambda { |day| where("(startime between ? and ?) or (endtime between ? and ?)", day, day+1, day, day+1)}
	
	scope :not_recurring,  where("recurring = ?", NOT_RECURRING)
	scope :recurring_daily, lambda { |day| where("recurring = ? and (? between startime and recurring_end)", RECURRING_EVERY_DAY, day) }
	scope :recurring_weekly, lambda { |day| where("recurring = ? and (? between startime and recurring_end)", RECURRING_EVERY_WEEK, day) }
	scope :recurring_monthly, lambda { |day| where("recurring = ? and (? between startime and recurring_end)", RECURRING_EVERY_MONTH, day) }
	scope :recurring_yearly, lambda { |day| where("recurring = ? and (? between startime and recurring_end)", RECURRING_EVERY_YEAR, day) }
	
	#many to many with resources (teacher or section or school)
	has_many :schedules, :dependent => :destroy
	has_many :teachers, :through => :schedules, :source => :attendee, :source_type => 'Teacher'
	has_many :sections, :through => :schedules, :source => :attendee, :source_type => 'Section'	
	has_many :branches, :through => :schedules, :source => :attendee, :source_type => 'Branch'
	
	validate :time_cannot_be_in_the_past	
	validate :startime_should_be_less_than_endtime	
	validate :attendees_cannot_be_empty
	validates :name, 	:presence => true, 
                       				:length => {:maximum => 50}
	validates :description, 	:length => {:maximum => 3000}          #The entire agenda may be presented here.     
	validates :recurring, :inclusion => { :in => [NOT_RECURRING, RECURRING_EVERY_DAY, RECURRING_EVERY_WEEK, RECURRING_EVERY_MONTH] }	        				
 		
	#Validation methods
	def time_cannot_be_in_the_past
		if startime < Date.today
			errors.add(:startime, "can't be in the past")
		end
		if endtime < Date.today
			errors.add(:endtime, "can't be in the past")
		end
		if recurring != NOT_RECURRING && recurring_end < Date.today
			errors.add(:recurring_end, "can't be in the past")
    	end
	end
	
	def startime_should_be_less_than_endtime
		if startime > endtime
			errors.add(:endtime, "should be later than start time")
		end
	end
	
	def attendees_cannot_be_empty
		if self.teachers.empty? && self.sections.empty? && self.branches.empty?
			errors.add_to_base("There are no attendees")
		end
	end
	
	
	def is_on?(day)
		day >= self.startime.to_date && day <= self.endtime.to_date
	end
	
	def recurring_every_year?
		recurring==RECURRING_EVERY_YEAR
	end	
	
	def recurring_every_month?
		recurring==RECURRING_EVERY_MONTH
	end
	
	def recurring_every_week?
		recurring==RECURRING_EVERY_WEEK
	end	
	
	def recurring_every_day?
		recurring==RECURRING_EVERY_DAY
	end
	
	def recurring_every_week_day?
		recurring==RECURRING_EVERY_WEEK_DAY
	end
	
	def recurring?
		recurring != NOT_RECURRING
	end
	

def self.on_date(day, object)
	@events = Event.for_object(object).on_day(day).all
	
	@events = @events + Event.for_object(object).recurring_daily(day).all
	@weekly_events = Event.for_object(object).recurring_weekly(day).all	
	@weekly_events.each do |we|
		if day.strftime("%A").eql? we.startime.strftime("%A")
			@events << we
		end
	end
	@monthly_events = Event.for_object(object).recurring_monthly(day).all		
	@monthly_events.each do |me|
		if day.day == me.startime.day
			@events <<  me
		end
	end
	return @events.uniq
end
	
end
