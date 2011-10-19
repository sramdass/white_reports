class TeachersController < ApplicationController
	
# for cancan authorization
load_and_authorize_resource
	
# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

 #-----------------------------------------------------------#

  def index
  	@teachers = Teacher.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
      format.js
    end
  end
  
#-----------------------------------------------------------#

  def show
    #@teacher = Teacher.find(params[:id])
    #Populate the resources on which this particular teacher has access
    @readable_sections = []
    @writable_sections = []
    @readable_branches = []
    @writable_branches = []
    
    if @teacher.teacher_contact
		profile = Profile.find_by_email(@teacher.teacher_contact.primary_email)
	end
	if profile
		Section.all.each do |s| 
			if can? (:update, s, profile) || can? (:update_section_elements, s, profile) || can? (:communicate, s, profile)
				@writable_sections << s 
			elsif can? (:read, s, profile)
				@readable_sections << s 
			end 
		end 
		Branch.all.each do |br| 
			if can? (:update, br, profile) || can? (:update_branch_elements, br, profile) || can? (:communicate, br, profile)
				@writable_branches << br
			elsif can? (:read, br, profile)
				@readable_branches << br
			end
		end
	end

  	@default_tab = 'show'
	render :actions_box
  end
  
  #-----------------------------------------------------------#

  def update
    #@teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
      	@default_tab = 'show'
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully updated') }
        format.xml  { head :ok }
      else
      	@default_tab = 'edit'
        format.html { render :actions_box }        
        format.xml  { render :xml => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  def destroy
    #@teacher = Teacher.find(params[:id])
    @teacher.destroy

    respond_to do |format|
      format.html { redirect_to(teacherss_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#

def edit
	#@teacher = Teacher.find(params[:id])
	if @teacher.teacher_contact.nil?
		@teacher.build_teacher_contact	
	end
  	@default_tab = 'edit'
	render :actions_box	
end	

#-----------------------------------------------------------#

def emailnew
	#@teacher = Teacher.find(params[:id])
  	@default_tab = 'emailnew'
	render :actions_box	
end	

#-----------------------------------------------------------#

def email	
	#@teacher = Teacher.find(params[:id])
	# to, cc, bcc, subject, message are part of the 'params' hash
	SchoolMailer.email_teacher(@teacher, params).deliver
	@default_tab='show'
	redirect_to(@teacher, :notice => 'Email Sent')	
end
#-----------------------------------------------------------#

def smsnew
	#@teacher = Teacher.find(params[:id])
  	@default_tab = 'smsnew'
	render :actions_box	
end	

#-----------------------------------------------------------#

def sms	
	#@teacher = Teacher.find(params[:id])
	message = Sms.new(params[:to], params[:message])
	message.send
	@default_tab='show'
	redirect_to(@teacher, :notice => 'Email Sent')
end

#-----------------------------------------------------------#

def actions_box
	#@teacher = Teacher.find(params[:id])
	@default_tab = 'show'
    respond_to do |format|
      format.html # actions_box.html.erb
      format.xml  { render :xml => @teacher }
    end	
end

#-----------------------------------------------------------#
  
   def sort_column
    Teacher.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
