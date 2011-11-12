# == Schema Information
#
# Table name: schedules
#
#  id            :integer         not null, primary key
#  attendee_id   :integer
#  attendee_type :string(255)
#  event_id      :integer
#  response      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Schedule < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendee, :polymorphic => true	
end
