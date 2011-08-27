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
