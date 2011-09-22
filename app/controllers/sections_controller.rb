class SectionsController < ApplicationController
	
# ---------------WHAT IS @default_tab?--------------------------#
	
# '@default_tab' determines what the user should view when - 1. there is a update
# action (action that needs to render other action's view to redirect), 2. when the 
# actions_box view is rendered. According to the '@default_tab' value, a particular
# tab will be selected in the actions_box's view	
# --------------------------------------------------------------#	

# for cancan authorizatoin
load_and_authorize_resource

# Make sure there is a valid mark table and a @test object before you view the section.
# if @test==nil, there will be problems in the views since we are rendering all the actions (with different divs)	
# if there is no mark table, no table will be displayed by default in the update marks tab
before_filter :initialize_test_and_marks_table, :only => [:show, :edit, :actions_box, :stunew, :marknew]

# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

  def index
 	@sections = Section.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sections }
      format.js
    end
  end

  def show
    #@section = Section.find(params[:id])
  	@default_tab = 'show'
	render :actions_box
=begin
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
=end
  end
  
  
  def edit
    #@section = Section.find(params[:id])
  	@default_tab = 'edit'
	render :actions_box
  end


	def update
		#@section = Section.find(params[:id])
		@default_tab = 'show'   		
		params[:section][:subject_ids] ||= []
		params[:section][:test_ids] ||= []
		@section.attributes = params[:section]
		# This section is for updating the teacher for a particular section + subject.
		#Note that the subjects and the tests will be updated automatically (without any parsing)
		@section.sec_sub_maps.each do |d|
		    sid = d.subject_id
		    d.attributes = {:subject_id => sid, :teacher_id => params["teacher"]["#{sid}"]}
		end
		
		#ret = mark_table("sec_#{@section.id}_#{current_year}_marks", params[:section])
=begin		
		if ret
			flash[:notice] = "Marks table created"
			logger.debug "This is the log message!!!"
			#	logger.debug_variables(binding)
		else
			flash[:error] = "Marks table error"
			logger.debug "This is the log error message!!!"
			# logger.debug_variables(binding)
		end
=end		
		if @section.valid? && @section.sec_sub_maps.all?(&:valid?) # &&  ret
			@section.save!
			@section.sec_sub_maps.each(&:save!)
			@default_tab='show'
			
		# Whenever the list of tests for a section changes. update the marks table with rows for that test
		# If this is not done - there might be problems. However, since there is a redirect, we should not 
		# have any problem. Various use cases should be tested for this scenario
			for test_id in params[:section][:test_ids]
				build_marks_table(@section.id, test_id)				
			end
			
			redirect_to (@section,  :notice => 'Section was successfully updated.')
		else
	    	@default_tab = 'edit'
	        format.html { render :actions_box }
		end
	end

#-----------------------------------------------------------#
  
  def stunew
  	#@section = Section.find(params[:id])
	@default_tab = 'stunew'
	render :actions_box
  end
  
#-----------------------------------------------------------#

  def stucreate
  	 #@section = Section.find(params[:id])
	respond_to do |format|
	    if @section.update_attributes(params[:section])
			@default_tab='show'
	        format.html { redirect_to (@section,  :notice => 'Students were successfully updated.')}
	    	format.xml  { head :ok }
	    else
	    	@default_tab = 'stunew'
	        format.html { render :actions_box }
	        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
	    end
    end
  end

#-----------------------------------------------------------#
  
  def marknew
  	#@section = Section.find(params[:id])
	@test = Test.find(params[:test_id]) || Test.first
  	@default_tab = 'marknew'	  	
	render :actions_box
  end
  
#-----------------------------------------------------------#

  def markcreate
  	 #@section = Section.find(params[:id])
	respond_to do |format|
	    if @section.update_attributes(params[:section])
			@default_tab='show'

			
	        format.html { redirect_to (@section,  :notice => 'Students were successfully updated.')}
	    	format.xml  { head :ok }
	    else
	    	@default_tab = 'stunew'
	        format.html { render :actions_box }
	        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
	    end
    end
  end

#-----------------------------------------------------------#

def actions_box
	 #@section = Section.find(params[:id])
	@default_tab = 'show'
    respond_to do |format|
      format.html # actions_box.html.erb
      format.xml  { render :xml => @section }
    end	
end
#-----------------------------------------------------------#

   def sort_column
    Section.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  #-----------------------------------------------------------#
  
	def initialize_test_and_marks_table
		@section ||= Section.find(params[:id])
		if params[:test_id]
			@test = Test.find(params[:test_id]) || Test.first	
		else		
			@test = @section.tests.first
		end		
		build_marks_table(@section.id, @test.id)
	end
  
#-----------------------------------------------------------#
		
end
