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
		format.js
	end
end

  def show
    #@section = Section.find(params[:id])
  	@default_tab = 'show'
	render :actions_box
  end
  
  
  def edit
    #@section = Section.find(params[:id])
  	@default_tab = 'edit'
	render :actions_box
  end


	def update
	#This will have the list of events that are created for the test maps that do not have a event associated.
	#Incase this edit fails during the validation of all the objects, we need to delete these events.
	#Now, you are thinking - Why can we save these after validation?
	# Beacause we need the event ids before the validation to put inside the test map attributes and we dont
	#get an event_id until we save a particular event.....	
	#In case an exception happens, the events in this array has to be deleted. This is to make sure that we 
	#do not have orphan events in the scenario when an exception happens after a save is triggered.
	delete_events_at_validation_failure = []
	delete_events_at_successful_save = []	
	old_sec_test_maps = []
	
		#@section = Section.find(params[:id])
		@default_tab = 'show'   		
		params[:section][:subject_ids] ||= []
		params[:section][:test_ids] ||= []
				
		#We need to have the difference between the old test maps and the new test maps.
		#The events corresponding to each of the difference have to be deleted. The difference
		#has all the tests that were in this section previously and will be deleted now because
		#those tests have been unchecked in the edit seciton page.
		
		#Note: I cannot simply write -> old_sec_test_maps = @section.sec_test_maps
		#If I do that old_sec_test_maps behaves like a pointer. Whenever @section.sec_test_maps
		# is updated, this old_sec_test_maps also gets changed. Baffling behaviour!!! Whatever you say, Rails!
		@section.sec_test_maps.each do |s|
			old_sec_test_maps << s
		end
		
		#TODO - 
		#This has to be modified with collections.build() method. If assigned like this,it will do a auto-save.
		#In case of any exception after this point, we would not be able to roll back
		#Refer - http://guides.rubyonrails.org/association_basics.html
		#It says:
		#When you assign an object to a has_and_belongs_to_many association, that object is automatically saved 
		#(in order to update the join table). If you assign multiple objects in one statement, then they are all saved.
		#If you want to assign an object to a has_and_belongs_to_many association without saving the object, use the collection.build method.
		@section.attributes = params[:section]
				
		# This section is for updating the teacher for a particular section + subject.
		#Note that the subjects and the tests will be updated automatically (without any parsing)
		@section.sec_sub_maps.each do |d|
		    sid = d.subject_id
		    mark_col = mark_column(sid)
		    if mark_col != -1
		    	d.attributes = 	{
		    								:subject_id => sid, 
		    								:teacher_id => params["teacher"]["#{sid}"], 
		    								:max_marks => params["max_marks"]["#{sid}"],
		    								:pass_marks => params["pass_marks"]["#{sid}"],
		    								:mark_column => mark_col
		    								}
		    else
			    @default_tab = 'edit'
		        render :actions_box, :error => "Cannot update mark column in the section subject maps"
		        return
			end
		end			
		
		#This array will have the list of events that have to be validated along with the section and sectest maps.
		#Technically, this array will have a list of events that are already mapped to a particular sec_test_map
		#that  will again be updated in this action. Yes, I am confused, too!
		events_to_be_validated = []	
		#Update the startdate and enddate for each of the tests of this particular section
		@section.sec_test_maps.each do |stmap|
			tid = stmap.test.id
			sdate = params["startdate"]["#{tid}"].to_date
			edate = params["enddate"]["#{tid}"].to_date
			
			#The timings  have to be changed, depending on the period timings the branch is gonna have
			stime = Time.gm(sdate.year, sdate.month, sdate.day, 9, 0) #start from 9 0 clock that day
			etime = Time.gm(sdate.year, sdate.month, sdate.day, 11, 0) #end at 11 0 clock that day
			test_name = Test.find(tid).name
		    			
			event_attributes = Hash.new
			event_attributes = { 	
												:name => test_name,
												:startime => stime,
												:endtime =>  etime,
												:recurring => Event::RECURRING_EVERY_DAY,
												:description => test_name,
												:recurring_end => edate
												}
			
			event = nil; #make sure that the scope of this variable is not narrowed only to the following if-else
			#If the event is 0 or nil, it means that an event has not been created for this particular test
			if stmap.event_id ==0 or !stmap.event_id
				event = Event.new(event_attributes)
				event.sections = [@section]
				if event.save
					#This array will be used to roll back all the save events in case this whole section edit goes to failure
					delete_events_at_validation_failure << event
				else
					@default_tab = 'edit'
					flash[:error] = "Cannot create associated event"
	        		render :actions_box
	        		return
				end
			else
				event = Event.find(stmap.event_id)
				event.attributes = event_attributes
				events_to_be_validated << event
			end
			
	    	stmap.attributes = 	{
	    								:test_id => tid, 
	    								:startdate => sdate,
	    								:enddate => edate,
	    								:event_id => event.id  #This is why we have to save the new events, to get the event.id
	    								}
		end	# End of - @section.sec_test_maps.each do |stmap|
		
		if @section.valid? && @section.sec_sub_maps.all?(&:valid?) && @section.sec_test_maps.all?(&:valid?) && events_to_be_validated.all?(&:valid?)
			#Save the events that have been edited
			events_to_be_validated.each(&:save!)
			@section.save!
			@section.sec_sub_maps.each(&:save!)
			@section.sec_test_maps.each(&:save!)

			#This is the difference between the sec_test_maps the section already had and the sec_test_maps
			# the section has now (as a result of this edit). The events corresponding to all the sec_test_maps
			#in the difference have to be deleted.
			#We have to delete it manually becuase, when a new set of sec_test_maps are assigned to the section,
			#the old set of sec_test_maps will be deleted, NOT DESTROYED. The associated events will get deleted
			#(coz of the sec_test_maps belongs_to) only if the sec_test_maps events are destroyed. Here only delete
			#happens when the sec_test_maps are automatically assigned to the seciton.
			
			#Refer - http://guides.rubyonrails.org/association_basics.html.
			#It says - ' Automatic deletion of join models is direct, no destroy callbacks are triggered. '
			diff_sec_test_maps = old_sec_test_maps -  Section.find(@section.id).sec_test_maps #@section is not getting refreshed here
			diff_sec_test_maps.each do |map|
				delete_events_at_successful_save << Event.find(map.event_id)
			end			
			delete_events(delete_events_at_successful_save)		
			@default_tab='show'
			
			# Whenever the list of tests for a section changes. update the marks table with rows for that test
			# If this is not done - there might be problems. However, since there is a redirect, we should not 
			# have any problem. Various use cases should be tested for this scenario
			for test_id in params[:section][:test_ids]
				build_marks_table(@section.id, test_id)				
			end			
			redirect_to(@section,  :notice => 'Section was successfully updated.')
		else
			delete_events(delete_events_at_validation_failure)
			@default_tab = 'edit'
	    	flash[:notice] = "Validation failed for the section"
	        render :actions_box
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
    if @section.update_attributes(params[:section])
		@default_tab='show'
			redirect_to(@section,  :notice => 'Students were successfully updated.')
    else
    	@default_tab = 'stunew'
        render :actions_box
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
    if @section.update_attributes(params[:section])
		@default_tab='show'			
		redirect_to(@section,  :notice => 'Marks were successfully updated.')    	
    else
    	@default_tab = 'stunew'
        render :actions_box
    end
  end

#-----------------------------------------------------------#
 
  def timetablenew
  	#@section = Section.find(params[:id])
	@default_tab = 'timetablenew'
	render :actions_box
  end
  
#-----------------------------------------------------------#

  def timetablecreate
  	 #@section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
		@default_tab='show'
		redirect_to(@section,  :notice => 'Timetable was successfully updated.')
    else
    	@default_tab = 'timetablenew'
        render :actions_box
    end
  end

#-----------------------------------------------------------#

def actions_box
	 #@section = Section.find(params[:id])
	@default_tab = 'show'
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
  
	def mark_column(sub_id)
		temp_row = @section.sec_sub_maps.find_by_subject_id(sub_id)
		if temp_row.mark_column	
			return temp_row.mark_column
		else
			cols = (1..MARKS_SUBJECTS_COUNT).to_a
			@section.sec_sub_maps.each do |map|
			cols.delete_if {|x| x == map.mark_column}
			end			
			return cols[0] if !cols.empty?
			return -1	
		end	
	end
#-----------------------------------------------------------#	
	def initialize_test_and_marks_table
		@section ||= Section.find(params[:id])
		if params[:test_id]
			@test = Test.find(params[:test_id])
		else		
			@test = @section.tests.first
		end
		if @test
			build_marks_table(@section.id, @test.id)
		end
	end	
#-----------------------------------------------------------#

	def build_marks_table(section_id, test_id)
		@section = Section.find(section_id)
		marks = Mark.find(:all,:conditions => {:section_id.eq => section_id, :test_id.eq => test_id })
	 	if (marks.empty?)
	 		for student in @section.students 
	 			m = Mark.new( {:section_id => @section.id, :test_id => test_id, :student_id => student.id })
	 			m.save!
	 		end
		end 				
		if marks.count < @section.students.count
			@section.students.each do |student|
				mark = Mark.find(:all,:conditions => {:section_id.eq => section_id, :test_id.eq => test_id, :student_id => student.id })
				if (mark.empty?)
					m = Mark.new( {:section_id => @section.id, :test_id => test_id, :student_id => student.id })
					m.save!
				end
			end
		end
	end		
#-----------------------------------------------------------#	

	def delete_events(events)
		if !events.empty?
			events.each do |e|
				e.destroy
			end
		end
	end
	
#-----------------------------------------------------------#	

		
end
