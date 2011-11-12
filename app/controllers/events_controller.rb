class EventsController < ApplicationController
  
  # GET /events
  # GET /events.xml
  def index
	if params[:teacher_id]
		@object = Teacher.find(params[:teacher_id])
	elsif params[:section_id]
		@object = Section.find(params[:section_id])
	elsif params[:branch_id]
		@object = Teacher.find(params[:branch_id])
	end  	
 	@events = @object.events
 	@d = Date.today
  end

#-----------------------------------------------------------#

  # GET /events/1
  # GET /events/1.xml
  def show
	@event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
 end

#-----------------------------------------------------------#

  # GET /events/new
  # GET /events/new.xml
  def new
   @event = Event.new
   branch_id = current_profile.user_profile.branch.id  #Assuming only teachers are able to create events now.
   @branch = Branch.find(branch_id)
  end

#-----------------------------------------------------------#

  # GET /events/1/edit
  def edit
   @event = Event.find(params[:id])
	@branch = Branch.find(5) #The branch has to be assigned an appropriate value   
  end

#-----------------------------------------------------------#

  # POST /events
  # POST /events.xml
	def create
		@event = Event.new(params[:event])
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
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

def actions_box
	@default_tab = 'calendar'
end	

#-----------------------------------------------------------#

  def calendar


  end


  

end  
  