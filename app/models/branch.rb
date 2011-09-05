# == Schema Information
#
# Table name: branches
#
#  id             :integer         not null, primary key
#  institution_id :integer
#  name           :string(255)
#  id_no          :string(255)
#  type           :string(255)
#  principal      :string(255)
#  address        :string(255)
#  city           :string(255)
#  state          :string(255)
#  pin            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Branch < ActiveRecord::Base
	belongs_to :institution
	
	has_many :clazzs, :dependent => :destroy
	accepts_nested_attributes_for :clazzs, :reject_if => lambda { |attr|  attr[:name].blank?}, :allow_destroy => true
	
	has_many :teachers, :dependent => :destroy
	accepts_nested_attributes_for :teachers, :reject_if => lambda { |attr|  attr[:name].blank?  &&  attr[:id_no].blank?  &&   attr[:female].blank?}, :allow_destroy => true
		
	has_many :subjects, :dependent => :destroy
	accepts_nested_attributes_for :subjects, :reject_if => lambda { |attr|  attr[:name].blank? },  :allow_destroy => true
	
	has_many :tests, :dependent => :destroy
	accepts_nested_attributes_for :tests, :reject_if => lambda { |attr|  attr[:name].blank? },  :allow_destroy => true
	
	#-------- INSTANCE MODULES --------#
    def self.search(search)
		if search
			where('name LIKE ?', "%#{search}%")
		else
			scoped
		end
	end
	
end
