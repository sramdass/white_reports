class Mark < ActiveRecord::Base
	belongs_to :section
	belongs_to :student
	belongs_to :test
	
scope :by_test_id, lambda { |id| where(:test_id => id) }
scope :by_section_id, lambda { |id| where(:section_id => id)}
scope :by_student_id, lambda { |id| where(:student_id => id)}
scope :boys_only, joins(:student).where('students.female = ?', false)
scope :girls_only, joins(:student).where('students.female = ?', true)
scope :in_range, lambda { |mark_col, lower_range, upper_range| where(mark_col.to_sym => (lower_range..upper_range))}

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

def self.total_on(section_id, subject_id, test_id)
	column_name = SecSubMap.by_section_id(section_id).by_subject_id(subject_id).first.mark_column
	column_name = "sub#{column_name}"
	where('section_id = ? and test_id = ?', section_id, test_id).sum(column_name.to_sym)
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
