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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teacher }
    end
  end
  
  #-----------------------------------------------------------#

  def update
    #@teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
end	

#-----------------------------------------------------------#

def emailnew
	#@teacher = Teacher.find(params[:id])
end	

#-----------------------------------------------------------#

def email	
	#@teacher = Teacher.find(params[:id])
	# to, cc, bcc, subject, message are part of the 'params' hash
	SchoolMailer.email_teacher(@teacher, params).deliver
	redirect_to(@teacher, :notice => 'Email Sent')
end
#-----------------------------------------------------------#

def smsnew
	#@teacher = Teacher.find(params[:id])
end	

#-----------------------------------------------------------#

def sms	
	#@teacher = Teacher.find(params[:id])
	message = Sms.new(params[:to], params[:message])
	message.send

	redirect_to(@teacher, :notice => 'Message Sent')
end
#-----------------------------------------------------------#
  
   def sort_column
    Teacher.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
