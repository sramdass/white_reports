# == Schema Information
#
# Table name: sections
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  class_teacher_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  clazz_id         :integer
#

class Section < ActiveRecord::Base
	belongs_to :clazz
	
	has_many :sec_sub_maps, :dependent => true, :dependent => :destroy
	has_many :subjects, :through => :sec_sub_maps
	
	has_many :sec_test_maps, :dependent => true, :dependent => :destroy
	has_many :tests, :through => :sec_test_maps
	
	has_many :students, :dependent => :destroy
	accepts_nested_attributes_for :students, :reject_if => lambda { |attr|  attr[:name].blank?  &&  attr[:id_no].blank?  &&   attr[:female].blank? && attr[:female].blank? }, :allow_destroy => true
	
	validates	:name,  :presence => true, 
                   		:length => {:minimum => 1, :maximum => 20}
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end   
	
end
