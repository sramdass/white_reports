# == Schema Information
#
# Table name: mark_rec_defns
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  subject_id_list :string(255)
#  hash_value      :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class MarkRecDefn < ActiveRecord::Base
	 validates 	:name, :presence => true, 
                    	:uniqueness => true

end
