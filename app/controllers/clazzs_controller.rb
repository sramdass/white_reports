class ClazzsController < ApplicationController
	
# ---------------WHAT IS @default_tab?--------------------------#
	
# '@default_tab' determines what the user should view when - 1. there is a update
# action (action that needs to render other action's view to redirect), 2. when the 
# actions_box view is rendered. According to the '@default_tab' value, a particular
# tab will be selected in the actions_box's view	
# --------------------------------------------------------------#	

	
# for cancan authorizatoin
load_and_authorize_resource

#-----------------------------------------------------------#	
# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

#-----------------------------------------------------------#
 
  # GET /clazzs
  # GET /clazzs.xml
  def index
  	@clazzs = Clazz.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clazzs }
      format.js
    end
  end

#-----------------------------------------------------------#

  # GET /clazzs/1
  # GET /clazzs/1.xml
  def show
    #@clazz = Clazz.find(params[:id])
  	@default_tab = 'show'
	render :actions_box
=begin	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clazz }
    end
=end    
  end

#-----------------------------------------------------------#

  # GET /clazzs/new
  # GET /clazzs/new.xml
  def new
    #@clazz = Clazz.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clazz }
    end
  end

#-----------------------------------------------------------#

  # GET /clazzs/1/edit
  def edit
    #@clazz = Clazz.find(params[:id])
  	@default_tab = 'edit'
	render :actions_box    
  end

#-----------------------------------------------------------#

  # POST /clazzs
  # POST /clazzs.xml
  def create
    #@clazz = Clazz.new(params[:clazz])

    respond_to do |format|
      if @clazz.save
        format.html { redirect_to(@clazz, :notice => 'Class was successfully created.') }
        format.xml  { render :xml => @clazz, :status => :created, :location => @clazz }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clazz.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # PUT /clazzs/1
  # PUT /clazzs/1.xml
  def update
    #@clazz = Clazz.find(params[:id])

    respond_to do |format|
      if @clazz.update_attributes(params[:clazz])
		@default_tab = 'show'      	
        format.html { redirect_to (@clazz, :notice => 'Clazz was successfully updated.') }
        format.xml  { head :ok }
      else
    	@default_tab = 'edit'
        format.html { render :actions_box }
        format.xml  { render :xml => @clazz.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # DELETE /clazzs/1
  # DELETE /clazzs/1.xml
  def destroy
    #@clazz = Clazz.find(params[:id])
    @clazz.destroy

    respond_to do |format|
      format.html { redirect_to(clazzs_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#

def actions_box
    #@clazz = Clazz.find(params[:id])
	@default_tab = 'show'
    respond_to do |format|
      format.html # actions_box.html.erb
      format.xml  { render :xml => @section }
    end	
end

#-----------------------------------------------------------#
  
  def secnew
  	#@clazz = Clazz.find(params[:id])
  	@teachers = @clazz.branch.teachers
	@default_tab = 'secnew'
	render :actions_box  	
  end
  
#-----------------------------------------------------------#

  def seccreate
  	 #@clazz = Clazz.find(params[:id])
  	 respond_to do |format|
      if @clazz.update_attributes(params[:clazz])
		@default_tab='show'
		format.html { redirect_to(@clazz	, :notice => ' Classes were successfully updated.') }      	
        format.xml  { head :ok }
      else
	    @default_tab = 'secnew'
	    format.html { render :actions_box }      	        
        format.xml  { render :xml => @clazz.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
 
 def sort_column
    Clazz.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

#-----------------------------------------------------------#  

end

