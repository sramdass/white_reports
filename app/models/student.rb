# == Schema Information
#
# Table name: students
#
#  id         :integer         not null, primary key
#  section_id :integer
#  name       :string(255)
#  id_no      :string(255)
#  female     :boolean
#  dob        :date
#  created_at :datetime
#  updated_at :datetime
#

class Student < ActiveRecord::Base

#-------ASSOCIATIONS------------#		
	belongs_to :section
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :section		
	
	has_one :student_contact, :dependent => :destroy
	accepts_nested_attributes_for :student_contact
	
	has_many :marks, :dependent => :destroy
	
	scope :by_section, lambda { |section_id| 
		where('section_id = ?', section_id)
	}	
	
	scope :name_like, lambda { |name| 
		where('name like ?', name)
	}	
	
#-------VALIDATIONS------------#
	
	 validates 	:name, 	:presence => true, 
                       					:length => {:maximum => 50}
	 validates 	:id_no,	:presence => true, 
                       					:length => {:maximum => 20},
                       					:uniqueness => true
	 validates 	:female, :inclusion => { :in => [true, false] }
	 
#-------- INSTANCE MODULES --------#		
=begin	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end
=end

	def class_teacher?(teacher)
		if self.section.class_teacher_id == teacher.id		
			return true
		else
			return false
		end
	end
	
end
