# == Schema Information
#
# Table name: schools
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  location   :string(255)
#  principal  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class School < ActiveRecord::Base
	has_many :teachers, :dependent => :destroy
	accepts_nested_attributes_for :teachers, :reject_if => lambda { |attr|  attr[:name].blank?  &&  attr[:id_no].blank?  &&   attr[:female].blank?}, :allow_destroy => true
	
	has_many :sections, :dependent => :destroy
	accepts_nested_attributes_for :sections, :reject_if => lambda { |attr|  attr[:name].blank?  &&  attr[:class_teacher_id].blank?},  :allow_destroy => true
	
	has_many :subjects, :dependent => :destroy
	accepts_nested_attributes_for :subjects, :reject_if => lambda { |attr|  attr[:name].blank? },  :allow_destroy => true
	
	has_many :tests, :dependent => :destroy
	accepts_nested_attributes_for :tests, :reject_if => lambda { |attr|  attr[:name].blank? },  :allow_destroy => true
	
	 validates 	:name,  :presence => true, 
                       	:length => {:minimum => 1, :maximum => 50}
                       
	 validates 	:location, :length => {:minimum => 1, :maximum => 30}
                       
    validates 	:principal, :length => {:minimum => 1, :maximum => 50}
    
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end                      

end
