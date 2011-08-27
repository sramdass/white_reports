# == Schema Information
#
# Table name: profiles
#
#  id                     :integer         not null, primary key
#  email                  :string(255)
#  password_hash          :string(255)
#  password_salt          :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  password_digest        :string(255)
#  profile_type           :integer
#  profile_ptr            :integer
#

class Profile < ActiveRecord::Base
	
	#CONSTANTS
	# Numbers less than 10 need to have more priveleges than admin.
	#Numbers between 10 and 20 need have less priveleges than admin and more priveleges than teacher etc..
	PROFILE_TYPE_ADMIN = 10
	PROFILE_TYPE_TEACHER = 20
	PROFILE_TYPE_STUDENT = 30
	
	attr_accessible :email, :password, :password_confirmation, :role_ids

	
	has_many :memberships, :dependent => true, :dependent => :destroy
	has_many :roles, :through => :memberships	
	
	attr_accessor :password
	before_save :encrypt_password
	before_create { generate_token(:auth_token) }
	
	validates_confirmation_of :password
	validates_presence_of :password, :on => :create
	validates_presence_of :email
	validates_uniqueness_of :email
	

	def authenticate(password)	
		if self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
		  	self
		else
		  	nil
		end
	end


	def encrypt_password
		if password.present?
		  self.password_salt = BCrypt::Engine.generate_salt
		  self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end	
	
	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		SchoolMailer.password_reset(self).deliver
	end

	def generate_token(column)
		begin
		self[column] = SecureRandom.base64
		end while Profile.exists?(column => self[column])
	end

	def role_symbols
		roles.map do |role|
			role.name.underscore.to_sym
		end
	end
	
#--- Modules related to converting profile to the user type such as, student, teacher and admin --- #

	def self.user_type_and_ptr(profile)	
		h = Hash.new	
		if obj = StudentContact.find_by_primary_email(profile.email)
			h[:type] = Profile::PROFILE_TYPE_STUDENT
			h[:ptr] = obj.student.id
		elsif obj = TeacherContact.find_by_primary_email(profile.email)
			h[:type] = Profile::PROFILE_TYPE_TEACHER
			h[:ptr] = obj.teacher.id
		else
			h = nil
		end
		return h
	end

	def user_profile
		if self.profile_type == PROFILE_TYPE_ADMIN
			Admin.find(self.profile_ptr)
		elsif self.profile_type == PROFILE_TYPE_TEACHER
			Teacher.find(self.profile_ptr)
		elsif self.profile_type == PROFILE_TYPE_STUDENT
			Student.find(self.profile_ptr)
		else		
			#raise an exception here
		end
	end
	
	def user_profile_name
		user_profile.name
	end	
	
	#called from ability.rb
	def has_role?(role_name)
		 if self.roles.include?Role.find_by_name(role_name)
		 	return true
	 	else
	 		return false
 		end
	end
	
	def has_any_role?(role_names)
		for name in role_names do
			 if self.roles.include?Role.find_by_name(name)
			 	return true
		 	end
		end
 		return false
	end	

#--- -------------------------------END-------------------------------------------- #	
end
