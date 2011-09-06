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
#

class Profile < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation
	
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
end
