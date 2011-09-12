class StudentsController < ApplicationController

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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
#-----------------------------------------------------------#

  def update
    #@student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to(@student, :notice => 'Student was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
end	

#-----------------------------------------------------------#
  
def emailnew
	#@student = Student.find(params[:id])
end	

#-----------------------------------------------------------#

def email	
	#@student = Student.find(params[:id])
	# to, cc, bcc, subject, message are part of the 'params' hash
	SchoolMailer.email_student(@student, params).deliver
	redirect_to(@student, :notice => 'Email Sent')
end

#-----------------------------------------------------------#

def smsnew
	#@student = Student.find(params[:id])
end	

#-----------------------------------------------------------#

def sms	
	#@student = Student.find(params[:id])
	message = Sms.new(params[:to], params[:message])
	message.send

	redirect_to(@student, :notice => 'Message Sent')
end
#-----------------------------------------------------------#

   def sort_column
    Student.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
