class SectionsController < ApplicationController
	
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
    @section = Section.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
  end
  
  
  def edit
    @section = Section.find(params[:id])
    @subjects = @section.clazz.branch.subjects
    @teachers = @section.clazz.branch.teachers
    @tests = @section.clazz.branch.tests
    @title = "Edit Section"
  end


	def update
		params[:section][:subject_ids] ||= []
		params[:section][:test_ids] ||= []
		@section = Section.find(params[:id])
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
		else
			flash[:error] = "Marks table error"
		end
		
		if @section.valid? && @section.sec_sub_maps.all?(&:valid?)
			@section.save!
			@section.sec_sub_maps.each(&:save!)
			redirect_to @section
		else
			@title = "Edit Section"
			render 'edit'
		end
	end

#-----------------------------------------------------------#
  
  def stunew
  	@section = Section.find(params[:id])
  end
  
#-----------------------------------------------------------#

  def stucreate
  	 @section = Section.find(params[:id])
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
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
	def new_table?(table_name)
		if MarkRecDefn.find_by_name(table_name)
			return false
		else
			return true
		end
	end
  
  	def mark_table(table_name, params)
  		
  		fields = default_mark_fields
		if new_table?(table_name)
		  	params[:subject_ids].each do |sid|
				field_name = Subject.find(sid).name
				fields[field_name]=:float
			end
			ret = create_table(table_name, fields)
			
			#add a row for this new table in the 'mark_rec_defns' table
			recdefn = MarkRecDefn.new(:name => table_name)
			recdefn.save!			
			return ret
		else
			add_fields = Hash.new
			delete_fields = Array.new
			Mark.set_table_name(table_name)
			marks = Mark.new

  			params[:subject_ids].each do |sid|
				field_name = Subject.find(sid).name
				if !Mark.column_names.include?(field_name)
					add_fields[field_name]=:float
				end				
			end
			add_columns_to_table(table_name, add_fields) unless add_fields.empty?
			
			source_fields =  Mark.column_names
			source_fields.delete_if { |col| col == 'id' || col == 'created_at' || col == 'updated_at'}
			if  source_fields.count > params[:subject_ids].count + default_mark_fields.count
				target_fields = hash_to_keys_array(default_mark_fields)
				params[:subject_ids].each do |sid|
					target_fields << Subject.find(sid).name
				end
				source_fields.each do |col_name|
					delete_fields << col_name unless target_fields.include?(col_name)
				end
				delete_columns_from_table(table_name, delete_fields) unless delete_fields.empty?
			end
			
		end # end of if newtable
	end #end of mark_table
	
end
