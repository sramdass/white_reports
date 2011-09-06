class SchoolsController < ApplicationController

#-----------------------------------------------------------#	
# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

#-----------------------------------------------------------#
 
  # GET /schools
  # GET /schools.xml
  def index
  	
 	@schools = School.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
      format.js
    end
  end

#-----------------------------------------------------------#

  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

#-----------------------------------------------------------#

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

#-----------------------------------------------------------#

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

#-----------------------------------------------------------#

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save
        format.html { redirect_to(@school, :notice => 'School was successfully created.') }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => 'School was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#
  
  def tnew
  	@school = School.find(params[:id])
  end
  
#-----------------------------------------------------------#

  def tcreate
  	 @school = School.find(params[:id])
  	 respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => ' Teachers were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "tnew" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
  def secnew
  	@school = School.find(params[:id])
  	#@school.sections.build
  	@teachers = @school.teachers.all
  end

#-----------------------------------------------------------#
  
  def seccreate
  	 @school = School.find(params[:id])
  	 respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => ' Teachers were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "secnew" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
	def subnew
  		@school = School.find(params[:id])
  	end
  	
#-----------------------------------------------------------#
  	
  	 def subcreate
	  	 @school = School.find(params[:id])
	  	 respond_to do |format|
	      if @school.update_attributes(params[:school])
	        format.html { redirect_to(@school, :notice => ' Sections were successfully updated.') }
	        format.xml  { head :ok }
	      else
	        format.html { render :action => "subnew" }
	        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
	      end
    end
  end

#-----------------------------------------------------------#

	def testnew
  		@school = School.find(params[:id])
  	end
  	
#-----------------------------------------------------------#
  	
  	 def testcreate
	  	 @school = School.find(params[:id])
	  	 respond_to do |format|
	      if @school.update_attributes(params[:school])
	        format.html { redirect_to(@school, :notice => ' Tests were successfully updated.') }
	        format.xml  { head :ok }
	      else
	        format.html { render :action => "testnew" }
	        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
	      end
    end
  end

#-----------------------------------------------------------#
  
 def sort_column
    School.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

#-----------------------------------------------------------#  
end
