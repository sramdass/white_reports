# == Schema Information
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
	has_many :memberships, :dependent => true, :dependent => :destroy
	has_many :profiles, :through => :memberships	
end
