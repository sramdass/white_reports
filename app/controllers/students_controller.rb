class StudentsController < ApplicationController
	
# ---------------WHAT IS @default_tab?--------------------------#
	
# '@default_tab' determines what the user should view when - 1. there is a update
# action (action that needs to render other action's view to redirect), 2. when the 
# actions_box view is rendered. According to the '@default_tab' value, a particular
# tab will be selected in the actions_box's view	
# --------------------------------------------------------------#


# for cancan authorization
load_and_authorize_resource
	
helper_method :sort_column, :sort_direction

#-----------------------------------------------------------#

  def index
  	@students = Student.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
      format.js
    end
  end

#-----------------------------------------------------------#

  def show
    #@student = Student.find(params[:id])
  	@default_tab = 'show'
	render :action => 'actions_box'
=begin
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
=end
  end
  
#-----------------------------------------------------------#

  def update
    #@student = Student.find(params[:id])
	
    respond_to do |format|
      if @student.update_attributes(params[:student])
      	@default_tab = 'show'
        format.html { redirect_to(@student, :notice => 'Student was successfully updated') }
        format.xml  { head :ok }
      else
      	@default_tab = 'edit'
        format.html { render :action => 'actions_box' }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  def destroy
    #@student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#

def edit
	#@student = Student.find(params[:id])
	if @student.student_contact.nil?
		@student.build_student_contact	
	end		
  	@default_tab = 'edit'
	render :action => 'actions_box' 
end	

#-----------------------------------------------------------#
  
def emailnew
	#@student = Student.find(params[:id])
  	@default_tab = 'emailnew'
	render :action => 'actions_box' 
end	

#-----------------------------------------------------------#

def email	
	#@student = Student.find(params[:id])
	@default_tab = 'show'	
	# to, cc, bcc, subject, message are part of the 'params' hash
	SchoolMailer.email_student(@student, params).deliver
	@default_tab='show'
	redirect_to(@student, :notice => 'Email Sent')
end

#-----------------------------------------------------------#

def smsnew
	#@student = Student.find(params[:id])
  	@default_tab = 'smsnew'
	render :action => 'actions_box' 
end	

#-----------------------------------------------------------#

def sms	
	#@student = Student.find(params[:id])
	message = Sms.new(params[:to], params[:message])
	message.send
	@default_tab='show'
	redirect_to(@student, :notice => 'Email Sent')
end
#-----------------------------------------------------------#

def actions_box
	#@student = Student.find(params[:id])
	@default_tab = 'show'
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end	
end
#-----------------------------------------------------------#


   def sort_column
    Student.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
