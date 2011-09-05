class ProfilesController < ApplicationController
	def new
		@profile = Profile.new
	end

def create
	@profile = Profile.new(params[:profile])
	if @profile.save
			session[:profile_id] = @profile.id
			redirect_to schools_path, :notice => "Logged in!"
	else
		render "new"
	end
	end
end
