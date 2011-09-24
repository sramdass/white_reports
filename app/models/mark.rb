class Mark < ActiveRecord::Base
	belongs_to :section
	belongs_to :student
	belongs_to :test
=begin
	validates_presence_of :section
	validates_presence_of :student
	validates_presence_of :student
	
	validates :sub1, :numericality => true
	validates :sub2, :numericality => true
	validates :sub3, :numericality => true
	validates :sub4, :numericality => true
	validates :sub5, :numericality => true
	validates :sub6, :numericality => true
	validates :sub7, :numericality => true
	validates :sub8, :numericality => true
	validates :sub9, :numericality => true
	validates :sub10, :numericality => true
	validates :sub11, :numericality => true
	validates :sub12, :numericality => true
	validates :sub13, :numericality => true
	validates :sub14, :numericality => true
	validates :sub15, :numericality => true
	
	validates :total, :numericality => true
	validates :rank, :numericality => true
=end	
end
