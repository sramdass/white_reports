class Role < ActiveRecord::Base
	has_many :memberships, :dependent => true, :dependent => :destroy
	has_many :profiles, :through => :memberships	
end
