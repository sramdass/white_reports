class Schedule < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendee, :polymorphic => true	
end
