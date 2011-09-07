class ProfilesController < ApplicationController
	def new
		@profile = Profile.new
	end

def create
	@profile = Profile.new(params[:profile])
	@profile.profile_type = Profile::PROFILE_TYPE_TEACHER
	@profile.profile_ptr = TeacherContact.find_by_primary_email(@profile.email).teacher.id
	if @profile.save
			#log in the user who has signed up
			cookies[:auth_token] = @profile.auth_token
			redirect_to institutions_path, :notice => "Logged in!"
	else
		render "new"
	end
	end
	
	def edit
		@profile = Profile.find(params[:id])
		@roles = Role.find(:all)
		@roles  ||= []
		@title = "Edit profile"
	end
	
	def update
		params[:profile][:role_ids] ||= []
		@profile = Profile.find(params[:id])
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
	
end
