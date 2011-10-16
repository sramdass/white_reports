class ProfilesController < ApplicationController
	def new
		@profile = Profile.new
		#This needs to be set to get the header in the login page
		@login_screen=true
	end

def create
	
	@profile = Profile.new(params[:profile])
	
	#Make sure that this profile has a corresponding user in the database
	obj = Profile:: user_type_and_ptr(@profile)
	if obj
		@profile.profile_type =obj[:type]
		@profile.profile_ptr = obj[:ptr]
		#While creating assign appropriate roles
		params[:profile][:role_ids] ||=  default_roles(@profile.profile_type)
	else
		flash[:error] =  "Unable to sign up. Please contact the admin to add your primary email to your contacts"
	end
	
	#We have to set this params for the many to many association to take place. Not sure why!
	@profile.attributes = params[:profile]
	
	if obj && @profile.save # The order is important here. If the obj is nil, the profile should not be saved
		#log in the user who has signed up
		cookies[:auth_token] = @profile.auth_token
		redirect_to institutions_path, :notice => "Logged in!"
	else
		#render 'new' is not proper here, because we need to have the sign_up url (of course, this will redirect to new)
		redirect_to sign_up_path
	end
	end
	
	def edit
		@profile = Profile.find(params[:id])
		@roles = Role.find(:all) || []
	  	@default_tab = 'edit'
		render :actions_box		
	end
	
	def update
		@profile = Profile.find(params[:id])
		
		#cancan
		# 1. To update a student profile, the current user should be able to update that particular student's section.
		#For example, a class teacher can update all of her student's profile
		# 2. To update a teacher's profile, the current user should be able to update that particular teacher's branch.
		#For example, a moderator or admin of that school can update all the teachers in that particular school
		
		if @profile.profile_type == Profile::PROFILE_TYPE_STUDENT
			authorize! :update, @profile.user_profile.section			
		elsif @profile.profile_type == Profile::PROFILE_TYPE_TEACHER
			authorize! :update, @profile.user_profile.branch
		elsif @profile.profile_type == Profile::PROFILE_TYPE_ADMIN
			# I don't know what the heck should go here at this point of time. Needs updation!
		end 
		
		#If there are no roles during update, assign guest role
		role = Array.new
		role <<  Role.find_by_name('guest').id
		params[:profile][:role_ids] ||=  role
		
		#We have to set this params for the many to many association to take place. Not sure why!
		@profile.attributes = params[:profile]

		if @profile.save
			redirect_to @profile
		else
			@title = "Edit Profile"
			render 'edit', :id => @profile.id
		end		
	end
	
	def index
		@profiles = Profile.find(:all)		
		#TODO: cancan code should come here!
	end

	def show
		@profile = Profile.find(params[:id])
		#cancan
		# if you can read a particular resource(teacher/student), you can see the resource's profile
		authorize! :read, @profile.user_profile			
      	@default_tab = 'show'
		render :actions_box		
	end
	
	def actions_box
		@profile = Profile.find(params[:id])
		authorize! :read, @profile.user_profile			
		@default_tab = 'show'
	end

  
	def default_roles(profile_type)
		roles = Array.new
		if profile_type == Profile::PROFILE_TYPE_STUDENT
			roles << Role.find_by_name('student').id
		elsif profile_type == Profile::PROFILE_TYPE_TEACHER
			roles << Role.find_by_name('teacher').id
		else
			roles << Role.find_by_name('guest').id
		end
		return roles  	
	end
	
	def redirect
		if current_profile
			if current_profile.profile_type == Profile::PROFILE_TYPE_STUDENT
				redirect_to student_path(current_profile.user_profile)
			elsif current_profile.profile_type == Profile::PROFILE_TYPE_TEACHER
				redirect_to teacher_path(current_profile.user_profile)
			elsif current_profile.profile_type == Profile::PROFILE_TYPE_ADMIN
				# I don't know what the heck should go here at this point of time. Needs updation!
			end
		else
			redirect_to log_in_path
		end
	end
  
end
