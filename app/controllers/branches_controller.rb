class BranchesController < ApplicationController
	
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
 
  # GET /branches
  # GET /branches.xml
  def index
  	@branches = Branch.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @branches }
      format.js
    end
  end

#-----------------------------------------------------------#

  # GET /branches/1
  # GET /branches/1.xml
  def show
    #@branch = Branch.find(params[:id])
  	@default_tab = 'show'
	render :actions_box
=begin	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @branch }
    end
=end    
  end

#-----------------------------------------------------------#

  # GET /branches/new
  # GET /branches/new.xml
  def new
    #@branch = Branch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @branch }
    end
  end

#-----------------------------------------------------------#

  # GET /branches/1/edit
  def edit
    #@branch = Branch.find(params[:id])
  	@default_tab = 'edit'
	render :actions_box    
  end

#-----------------------------------------------------------#

  # POST /branches
  # POST /branches.xml
  def create
    #@branch = Branch.new(params[:branch])

    respond_to do |format|
      if @branch.save
        format.html { redirect_to(@branch, :notice => 'Branch was successfully created.') }
        format.xml  { render :xml => @branch, :status => :created, :location => @branch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # PUT /branches/1
  # PUT /branches/1.xml
  def update
    #@branch = Branch.find(params[:id])

    respond_to do |format|
      if @branch.update_attributes(params[:branch])
		@default_tab = 'show'      	
        format.html { redirect_to(@branch, :notice => 'Branch was successfully updated.') }
        format.xml  { head :ok }
      else
      	@default_tab = 'edit'
        format.html {render :actions_box }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#

  # DELETE /branches/1
  # DELETE /branches/1.xml
  def destroy
    #@branch = Branch.find(params[:id])
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to(branches_url) }
      format.xml  { head :ok }
    end
  end

#-----------------------------------------------------------#

def actions_box
    #@branch = branch.find(params[:id])
	@default_tab = 'show'
    respond_to do |format|
      format.html # actions_box.html.erb
      format.xml  { render :xml => @branch }
    end	
end

#-----------------------------------------------------------#
  
  def tchrnew
  	#@branch = Branch.find(params[:id])
	@default_tab = 'tchrnew'
	render :actions_box  	
  end
  
#-----------------------------------------------------------#

  def tchrcreate
  	 #@branch = Branch.find(params[:id])
  	 respond_to do |format|
      if @branch.update_attributes(params[:branch])
		@default_tab='teachers'
		format.html { redirect_to(@branch	, :notice => ' Teachers were successfully updated.') }      	
        format.xml  { head :ok }
      else
	    @default_tab = 'tchrnew'
	    format.html { render  :actions_box }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
  def clznew
  	#@branch = Branch.find(params[:id])
  	#@branch.sections.build
	@default_tab = 'clznew'
	render :actions_box  	
  end

#-----------------------------------------------------------#
  
  def clzcreate
  	 #@branch = Branch.find(params[:id])
  	 respond_to do |format|
      if @branch.update_attributes(params[:branch])
		@default_tab='classes'
		format.html { redirect_to(@branch	, :notice => ' Classes were successfully updated.') }      		
        format.xml  { head :ok }
      else
	    @default_tab = 'clznew'
	    format.html { render  :actions_box }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
	def subnew
  		#@branch = Branch.find(params[:id])
		@default_tab = 'subnew'
		render :actions_box  		
  	end
  	
#-----------------------------------------------------------#
  	
	def subcreate
	#@branch = Branch.find(params[:id])
		respond_to do |format|
			if @branch.update_attributes(params[:branch])
			@default_tab='subjects'
			format.html { redirect_to(@branch	, :notice => ' Subjects were successfully updated.') }      	  	
				format.xml  { head :ok }
			else
				@default_tab = 'subnew'
	    		format.html { render  :actions_box }
				format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
			end
		end
	end

#-----------------------------------------------------------#

	def testnew
  		#@branch = Branch.find(params[:id])
		@default_tab = 'testnew'
		render :actions_box  		
  	end
  	
#-----------------------------------------------------------#
  	
  	 def testcreate
	  	 #@branch = Branch.find(params[:id])
	  	 respond_to do |format|
	      if @branch.update_attributes(params[:branch])
			@default_tab='tests'
			format.html { redirect_to(@branch	, :notice => ' Tests were successfully updated.') }      	   	
	        format.xml  { head :ok }
	      else
		    @default_tab = 'testnew'
	    	format.html { render  :actions_box }
	        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
	      end
    end
  end

#-----------------------------------------------------------#

	def periodnew
  		#@branch = Branch.find(params[:id])
		@default_tab = 'periodnew'
		render :actions_box  		
  	end
  	
#-----------------------------------------------------------#
  	
  	 def periodcreate
	  	 #@branch = Branch.find(params[:id])
	  	 respond_to do |format|
	      if @branch.update_attributes(params[:branch])
			@default_tab='periods'
			format.html { redirect_to(@branch	, :notice => ' Periods were successfully updated.') }      	   	
	        format.xml  { head :ok }
	      else
		    @default_tab = 'periodnew'
	    	format.html { render  :actions_box }
	        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
	      end
    end
  end

#-----------------------------------------------------------#
  
 def sort_column
    Branch.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

#-----------------------------------------------------------#
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

#-----------------------------------------------------------#  
end
