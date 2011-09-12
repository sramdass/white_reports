class BranchesController < ApplicationController
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
  	@branches = Branch.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @branch }
    end
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
        format.html { redirect_to(@branch, :notice => 'Branch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
  
  def tchrnew
  	#@branch = Branch.find(params[:id])
  end
  
#-----------------------------------------------------------#

  def tchrcreate
  	 #@branch = Branch.find(params[:id])
  	 respond_to do |format|
      if @branch.update_attributes(params[:branch])
        format.html { redirect_to(@branch, :notice => ' Teachers were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "tnew" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
  def clznew
  	#@branch = Branch.find(params[:id])
  	#@branch.sections.build
  end

#-----------------------------------------------------------#
  
  def clzcreate
  	 #@branch = Branch.find(params[:id])
  	 respond_to do |format|
      if @branch.update_attributes(params[:branch])
        format.html { redirect_to(@branch, :notice => ' Classes were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "clznew" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

#-----------------------------------------------------------#
  
	def subnew
  		#@branch = Branch.find(params[:id])
  	end
  	
#-----------------------------------------------------------#
  	
  	 def subcreate
	  	 #@branch = Branch.find(params[:id])
	  	 respond_to do |format|
	      if @branch.update_attributes(params[:branch])
	        format.html { redirect_to(@branch, :notice => ' Subjects were successfully updated.') }
	        format.xml  { head :ok }
	      else
	        format.html { render :action => "subnew" }
	        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
	      end
    end
  end

#-----------------------------------------------------------#

	def testnew
  		#@branch = Branch.find(params[:id])
  	end
  	
#-----------------------------------------------------------#
  	
  	 def testcreate
	  	 #@branch = Branch.find(params[:id])
	  	 respond_to do |format|
	      if @branch.update_attributes(params[:branch])
	        format.html { redirect_to(@branch, :notice => ' Tests were successfully updated.') }
	        format.xml  { head :ok }
	      else
	        format.html { render :action => "testnew" }
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
