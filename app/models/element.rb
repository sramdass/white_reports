# == Schema Information
#
# Table name: elements
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Element < ActiveRecord::Base
end
