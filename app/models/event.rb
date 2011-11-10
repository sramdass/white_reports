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
	
	#many to many with resources (teacher or section or school)
	has_many :schedules, :dependent => :destroy
	has_many :teachers, :through => :schedules, :source => :attendee, :source_type => 'Teacher'
	has_many :sections, :through => :schedules, :source => :attendee, :source_type => 'Section'	
	  	
	RECURRING_EVERY_YEAR=0
	RECURRING_EVERY_MONTH=1
	RECURRING_EVERY_WEEK=2	
	RECURRING_EVERY_DAY=3
	RECURRING_EVERY_WEEK_DAY=4
	NOT_RECURRING = -1
	
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
	
def attendees
  self.schedulers.collect { |a| a.attendees }
end	
	
end
