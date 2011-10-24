class Mark < ActiveRecord::Base
	belongs_to :section
	belongs_to :student
	belongs_to :test
	
	validates_presence_of :section
	validates_presence_of :student
	validates_presence_of :test	
		
	scope :by_test_id, lambda { |id| where(:test_id => id) }
	scope :by_section_id, lambda { |id| where(:section_id => id)}
	scope :by_student_id, lambda { |id| where(:student_id => id)}
	scope :boys_only, joins(:student).where('students.female = ?', false)
	scope :girls_only, joins(:student).where('students.female = ?', true)
	scope :in_range, lambda { |mark_col, lower_range, upper_range| where(mark_col.to_sym => (lower_range..upper_range))}
	
	before_save :update_total, :update_arrears
	
	def update_total
		total = 0
		hsh = mark_columns_with_subject_ids(self.section) 
		hsh.each do |sub_id, col_name|
			if self.send(col_name)
				total = total + self.send(col_name)
			end
		end
		self.total=total	
	end
	
	def update_arrears
		arrears = 0	
		#This will get hsh[subject_id] = 'corresponding_mark_column' in the marks table
		hsh = mark_columns_with_subject_ids(self.section) 
		hsh.each do |sub_id, col_name|
			pass_marks = self.section.sec_sub_maps.find_by_subject_id(sub_id).pass_marks
			if self.send(col_name) != nil
				if self.send(col_name) < pass_marks
					arrears = arrears + 1
				end
			end
		end
		self.arrears=arrears
	end
	
	def self.total_on(section_id, subject_id, test_id)
		column_name = SecSubMap.by_section_id(section_id).by_subject_id(subject_id).first.mark_column
		column_name = "sub#{column_name}"
		where('section_id = ? and test_id = ?', section_id, test_id).sum(column_name.to_sym)
	end
	
	
	#This will return a hash with each of the subject id of the section as the key and the corresponding mark column as the value
	def mark_columns_with_subject_ids(section)
		h = Hash.new
		section.sec_sub_maps.each do |map|
			name =map.subject_id
			mark_col = "sub#{map.mark_column}"
			h[name] = mark_col
		end
		return h
	end	
				
=begin
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
