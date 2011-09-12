class SectionsController < ApplicationController

# for cancan authorizatoin
load_and_authorize_resource
	
# Helper methods that will also be used in the view (index.html) 
# These methods can also be moved into the model, and in that 
# case, these methods cannot be accessed from the views
# TODO to see if there is a better place for this functions

helper_method :sort_column, :sort_direction

  def index
 	@sections = Section.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sections }
      format.js
    end
  end

  def show
    #@section = Section.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
  end
  
  
  def edit
    #@section = Section.find(params[:id])
    @subjects = @section.clazz.branch.subjects ||= []
    @teachers = @section.clazz.branch.teachers ||= []
    @tests = @section.clazz.branch.tests ||= []
    @title = "Edit Section"
  end


	def update
		#@section = Section.find(params[:id])
		params[:section][:subject_ids] ||= []
		params[:section][:test_ids] ||= []
		@section.attributes = params[:section]
		
		# This section is for updating the teacher for a particular section + subject.
		#Note that the subjects and the tests will be updated automatically (without any parsing)
		@section.sec_sub_maps.each do |d|
		    sid = d.subject_id
		    d.attributes = {:subject_id => sid, :teacher_id => params["teacher"]["#{sid}"]}
		end
		
		ret = mark_table("sec_#{@section.id}_#{current_year}_marks", params[:section])
		
		if ret
			flash[:notice] = "Marks table created"
			logger.debug "This is the log message!!!"
			#	logger.debug_variables(binding)
		else
			flash[:error] = "Marks table error"
			logger.debug "This is the log error message!!!"
			# logger.debug_variables(binding)
		end
		
		if @section.valid? && @section.sec_sub_maps.all?(&:valid?) &&  ret
			@section.save!
			@section.sec_sub_maps.each(&:save!)
			redirect_to @section
		else
			@title = "Edit Section"
			render 'edit', :id => @section.id
		end
	end

#-----------------------------------------------------------#
  
  def stunew
  	#@section = Section.find(params[:id])
  end
  
#-----------------------------------------------------------#

  def stucreate
  	 #@section = Section.find(params[:id])
  	 respond_to do |format|
	    if @section.update_attributes(params[:section])
	    	format.html { redirect_to(@section, :notice => ' Students were successfully updated.') }
	    	format.xml  { head :ok }
	    else
	        format.html { render :action => "stunew" }
	        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
	    end
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
	def new_table?(table_name)
		if MarkRecDefn.find_by_name(table_name)
			return false
		else
			return true
		end
	end
#-----------------------------------------------------------#  
  	def mark_table(table_name, params)

  		# return as soon as an error is enconuntered. Othewise there is a chance that this true is returned
  		ret = true
  		columns = default_mark_columns
		if new_table?(table_name) # Table for this 'section + year' is not there yet
		  	params[:subject_ids].each do |sid|
				column_name = Subject.find(sid).name
				columns[column_name]=:float
			end
			ret = create_table(table_name, columns)
			if ret
				#add a row for this new table in the 'mark_rec_defns' table
				recdefn = MarkRecDefn.new(:name => table_name)
				recdefn.save!
			end
			return ret
			
		else #Table is already there, just alter it
			add_columns = Hash.new
			delete_columns = Array.new
			Mark.set_table_name(table_name)
			marks = Mark.new

			#add the new columns(only marks) here
  			params[:subject_ids].each do |sid|
				column_name = Subject.find(sid).name
				add_columns[column_name]=:float unless Mark.column_names.include?(column_name)
			end

			if !add_columns.empty?
				if add_columns_to_table(table_name, add_columns) 
					Mark.reset_column_information()
					#Mark.set_table_name(table_name)
				else
					return false
				end				
			end
					
			#remove the unwanted columns (only marks) here
			source_columns =  Mark.column_names
			
			#following columns should not be deleted from the table
			source_columns.delete_if { |col| col == 'id' || col == 'created_at' || col == 'updated_at'}
			
			#default marks columns
			if  source_columns.count > params[:subject_ids].count + default_mark_columns.count
				target_columns = hash_to_keys_array(default_mark_columns)
				params[:subject_ids].each do |sid|
					target_columns << Subject.find(sid).name
				end
				source_columns.each do |col_name|
					delete_columns << col_name unless target_columns.include?(col_name)
				end
				ret = delete_columns_from_table(table_name, delete_columns) unless delete_columns.empty?
				return ret
			end
			
			return ret			
			
		end # end of if newtable
	end #end of mark_table
	
end
