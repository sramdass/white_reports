class EventsController < ApplicationController
  
  # GET /events
  # GET /events.xml
  def index
  	initialize_object_and_day
 	@events = @object.events
  end

#-----------------------------------------------------------#

  # GET /events/1
  # GET /events/1.xml
  def show
  	@event = Event.find(params[:id])
	initialize_object_and_day  	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @institutions }
      format.js
    end	
 end

#-----------------------------------------------------------#

  # GET /events/new
  # GET /events/new.xml
  def new
   @event = Event.new
	initialize_object_and_day   
	initialize_branch
  end

#-----------------------------------------------------------#

  # GET /events/1/edit
  def edit
   @event = Event.find(params[:id])
	initialize_object_and_day
	initialize_branch	
  end

#-----------------------------------------------------------#

  # POST /events
  # POST /events.xml
	def create
		@event = Event.new(params[:event])
		#set the recurring fields to "not recurring" when the recurrance is not selected
		if !params[:event][:recurring]
			@event.recurring = Event::NOT_RECURRING
		end		
		@branch = Branch.find(params[:branch_id])
		t_ids = params[:teachers].split(",") || []
		sec_ids = params[:section_ids] || []
		teachers = []
		sections = []
		branches = []
		if t_ids.include?("0")
			teachers = Branch.find(params[:branch_id]).teachers
		else
			t_ids.each do |tid|
				teachers << Teacher.find(tid)
			end
		end
		sec_ids.each do |sid|
			sections << Section.find(sid)
		end
		if params[:branch_event]
			branches << Branch.find(params[:branch_id])
		end

		@event.teachers = teachers
		@event.sections = sections
		@event.branches = branches

		if @event.valid? && @event.schedules.all?(&:valid?)
			@event.save!
			@event.schedules.each(&:save!)	
			redirect_to(@event, :notice => 'Event was successfully created.')
		else
			flash[:notice] = 'Cannot create Event'			
			render :action => "new"
		end
	end		
		



#-----------------------------------------------------------#

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
	@event.attributes = params[:event]
	@branch = Branch.find(params[:branch_id])	 #This is needed in case the edit action has to rendered again
	
		t_ids = params[:teachers].split(",") || []
		sec_ids = params[:section_ids] || []
		teachers = []
		sections = []
		branches = []
		if t_ids.include?("0")
			teachers = Branch.find(params[:branch_id]).teachers
		else
			t_ids.each do |tid|
				teachers << Teacher.find(tid)
			end
		end
		sec_ids.each do |sid|
			sections << Section.find(sid)
		end
		if params[:branch_event]
			branches << Branch.find(params[:branch_id])
		end
		@event.teachers = teachers
		@event.sections = sections
		@event.branches = branches
		
		if @event.valid? && @event.schedules.all?(&:valid?)
			@event.save!
			@event.schedules.each(&:save!)	
			redirect_to(@event, :notice => 'Event was successfully updated.')
		else
			flash[:notice] = 'Cannot create Event'	
			render :action => 'edit'
		end	
  end

#-----------------------------------------------------------#

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
	initialize_object_and_day    
    @event.destroy
	render :index
  end
  
	def attendees_dyn_vals
		#elements_array = params[:elements].split(",") #params[:type] is an string of comma separated element ids
		name_like = "%#{params[:q]}%"
		@teachers = []
		@teachers = Teacher.where('name like ?', name_like).find(:all, :select => "name, id").map(&:attributes)
		#Add an option so that the user can select all the teachers in a single option. Make the id as zero.
		@teachers = @teachers + [{"name"=>"All Teachers", "id"=>0}]

		respond_to do |format|
			format.html
			format.json { render :json => @teachers }
		end	
	end
	
#-----------------------------------------------------------#
  def show_day
	initialize_object_and_day
	@events_on_day = Event.on_date(@d, @object).sort_by &:startime
  end
  
  #These initializations have to be made for most of the actions (show, edit, index & show_day)
  #to know the object whose calendar we are viewing.
  #In the edit and show actions, this is used to redirect back to the index page.
  	def initialize_object_and_day
	  	@object_type = params[:object_type]
		if @object_type.eql?("Teacher")
			@object = Teacher.find(params[:object_id])
		elsif @object_type.eql?("Section")
			@object = Section.find(params[:object_id])
		elsif @object_type.eql?("Branch")
			@object = Branch.find(params[:object_id])
		else
			@object = current_profile.user_profile
		end  	
		if params[:day]
			@d = params[:day].to_date
		else
			@d = Date.today
		end
	end
	
	#The branch has to initialized for the new and the edit actions. The branch_id value has to be passed as a 
	#hidden field from the new and edit to create and update respectively.
	def initialize_branch	
		if params[:branch_id]
			branch_id = params[:branch_id]
		else
			branch_id = current_profile.user_profile.branch.id  #Assuming only teachers are able to create events now.
		end
   		@branch = Branch.find(branch_id)
	end
	
end
	

  