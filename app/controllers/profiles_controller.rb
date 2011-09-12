class ProfilesController < ApplicationController
	def new
		@profile = Profile.new
	end

def create
	
	@profile = Profile.new(params[:profile])
	
	#Make sure that this profile has a corresponding user in the database
	obj =Profile:: user_type_and_ptr(@profile)
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
		@roles = Role.find(:all)
		@roles  ||= []
		@title = "Edit profile"
	end
	
	def update
		@profile = Profile.find(params[:id])
		
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

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
      format.js
    end
  end

  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end
  
	def default_roles(profile_type)
		roles = Array.new
		if profile_type == Profile::PROFILE_TYPE_STUDENT
			roles << Role.find_by_name('user').id
		elsif profile_type == Profile::PROFILE_TYPE_TEACHER
			roles << Role.find_by_name('teacher').id
		else
			roles << Role.find_by_name('guest').id
		end
		return roles  	
	end
  
end
