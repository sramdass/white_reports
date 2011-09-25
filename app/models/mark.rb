class Mark < ActiveRecord::Base
	belongs_to :section
	belongs_to :student
	belongs_to :test
	
scope :by_test_id, lambda { |id| where(:test_id => id) }
scope :by_section_id, lambda { |id| where(:section_id => id)}
scope :by_student_id, lambda { |id| where(:student_id => id)}

before_save :update_total

def update_total
	total = 0
	for i in 1..MARKS_SUBJECTS_COUNT
		if self.send("sub#{i}") != nil
			total = total + self.send("sub#{i}")
		end
	end
	self.total=total	
end

=begin
	validates_presence_of :section
	validates_presence_of :student
	validates_presence_of :student
	
	validates :sub1, :numericality => true
	validates :sub2, :numericality => true
	validates :sub3, :numericality => true
	validates :sub4, :numericality => true
	validates :sub5, :numericality => true
	validates :sub6, :numericality => true
	validates :sub7, :numericality => true
	validates :sub8, :numericality => true
	validates :sub9, :numericality => true
	validates :sub10, :numericality => true
	validates :sub11, :numericality => true
	validates :sub12, :numericality => true
	validates :sub13, :numericality => true
	validates :sub14, :numericality => true
	validates :sub15, :numericality => true
	
	validates :total, :numericality => true
	validates :rank, :numericality => true
=end	
end
