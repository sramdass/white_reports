# == Schema Information
#
# Table name: clazzs
#
#  id               :integer         not null, primary key
#  branch_id        :integer
#  name             :string(255)
#  class_teacher_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Clazz < ActiveRecord::Base
	belongs_to :branch
	
	has_many :sections, :dependent => :destroy
	accepts_nested_attributes_for :sections, :reject_if => lambda { |attr|  attr[:name].blank?}, :allow_destroy => true
	
	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end       
end
