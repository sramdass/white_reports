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
	
#-------ASSOCIATIONS------------#	
	belongs_to :branch
	#Whenever it is saved, make sure the object has a valid parent available
	validates_presence_of :branch	
	
	has_one :teacher_contact, :dependent => :destroy
	accepts_nested_attributes_for :teacher_contact, :reject_if => :has_only_destroy?,  :allow_destroy => true
	
	has_many :sec_sub_maps, :dependent => :destroy
	
	#refer event.rb to see how the relationship between teacher and event works
	
	has_many :schedules, :as => :attendee, :dependent => :destroy  #polymorphic assocation. 'resource' can be teacher, section or school etc..
	has_many :events, :through => :schedules   #for many to many relationship.

	
#-------VALIDATIONS------------#
	
	 validates 	:name, 	:presence => true, 
                       					:length => {:maximum => 50}
	 validates 	:id_no,	:presence => true, 
                       					:length => {:maximum => 20},
                       					:uniqueness => true
	 validates 	:female, :inclusion => { :in => [true, false] }
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end
	
	def role_symbols
		profile = Profile.find_by_email(self.teacher_contact.primary_email)
		profile.roles.map do |role|
			role.name.underscore.to_sym
		end
	end
	
	def profile
		if self.teacher_contact
			profile = Profile.find_by_email(self.teacher_contact.primary_email)
		else
			nil
		end		
	end
	
	def principal?
		profile = self.profile
		if profile && profile.has_role?('principal')
			return true
		ese
			return false
		end
	end	
	
	#Returns true if there is only "_destroy" attribute available for nested models.
	def has_only_destroy?(attrs)
	    attrs.each do |k,v|
	    	if k !="_destroy" && !v.blank?
	    		return false
	    	end
		end
		return true	
  	end		

end
