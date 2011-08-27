# == Schema Information
#
# Table name: memberships
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base
	belongs_to :role
	belongs_to :profile
end
