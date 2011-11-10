class EventsController < ApplicationController
  
  # GET /events
  # GET /events.xml
  def index
  	
 	@events = Event.all
 	@d = Date.today

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js
    end
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
   @branch = Branch.find(5) #The branch has to be assigned an appropriate value
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

#-----------------------------------------------------------#

  # GET /events/1/edit
  def edit
   @event = Event.find(params[:id])
  end

#-----------------------------------------------------------#

  # POST /events
  # POST /events.xml
	def create
		validity=true
		@event = Event.new(params[:event])
		if @event.valid?
			t_ids = params[:teachers].split(",")
			sec_ids = params[:section_ids]
			sch_list=[]
			t_ids.each do |tid|
				teacher = Teacher.find(tid)
				sch = Schedule.new
				sch.event=@event
				sch.attendee = teacher
				if sch.valid?
					sch_list<<sch
				else
					validity=false;
				end
			end
			sec_ids.each do |sec_id|
				section = Section.find(sec_id)
				sch = Schedule.new
				sch.event=@event
				sch.attendee = section
				if sch.valid?
					sch_list<<sch
				else
					validity=false;
				end				
			end
		else
			validity=false; #When the event itself is invalid, this will be assigned
		end
		if validity
			@event.save!
			sch_list.each do |sch|
				sch.save!
			end
			redirect_to(@event, :notice => 'Event was successfully created.')
		else
			render :action => "new"
		end
	end


#-----------------------------------------------------------#

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {render :actions_box }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
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
  

end  
  