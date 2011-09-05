# == Schema Information
#
# Table name: sec_test_maps
#
#  id         :integer         not null, primary key
#  section_id :integer
#  test_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class SecTestMap < ActiveRecord::Base
	belongs_to :section
	belongs_to :test
end
