class InstitutionsController < ApplicationController
	
# for cancan authorizatoin
load_and_authorize_resource

#-----------------------------------------------------------#	
# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

#-----------------------------------------------------------#
 
  # GET /institutions
  # GET /institutions.xml
  def index
  	
 	@institutions = Institution.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @institutions }
      format.js
    end
  end

#-----------------------------------------------------------#

  # GET /institutions/1
  # GET /institutions/1.xml
  def show
	 #@institution = Institution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @institution }
    end
  end

#-----------------------------------------------------------#

  # GET /institutions/new
  # GET /institutions/new.xml
  def new
     #@institution = Institution.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @institution }
    end
  end

#-----------------------------------------------------------#

  # GET /institutions/1/edit
  def edit
     #@institution = Institution.find(params[:id])
  end

#-----------------------------------------------------------#

  # POST /institutions
  # POST /institutions.xml
  def create
     #@institution = Institution.new(params[:institution])

    respond_to do |format|
      if @institution.save
        format.html { redirect_to(@institution, :notice => 'Institution was successfully created.') }
        format.xml  { render :xml => @institution, :status => :created, :location => @institution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # PUT /institutions/1
  # PUT /institutions/1.xml
  def update
    #@institution = Institution.find(params[:id])

    respond_to do |format|
      if @institution.update_attributes(params[:institution])
        format.html { redirect_to(@institution, :notice => 'Institution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # DELETE /institutions/1
  # DELETE /institutions/1.xml
  def destroy
    #@institution = Institution.find(params[:id])
    @institution.destroy

    respond_to do |format|
      format.html { redirect_to(institutions_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#
  
  def branchnew
  	#@institution = Institution.find(params[:id])
  end
  
#-----------------------------------------------------------#

  def branchcreate
  	 #@institution = Institution.find(params[:id])
  	 respond_to do |format|
      if @institution.update_attributes(params[:institution])
        format.html { redirect_to(@institution, :notice => ' Branches were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "branchnew" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
 
 def sort_column
    Institution.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

#-----------------------------------------------------------#  

end
