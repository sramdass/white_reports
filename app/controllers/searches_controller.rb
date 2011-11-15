class SearchesController < ApplicationController
 	helper_method :mark_columns	 #Making this as a helper method because this method will be invoked from the view also.
	
	 def section_searches_box
	 	if !params[:section_id]
		 	@section = Section.first
	 	else
	 		@section = Section.find(params[:section_id])
 		end
		authorize! :read, @section	 		
 		@default_tab='students'
	 end
	 
	 def section_students
	 	@section=Section.find(params[:section_id])
	 	@students = Student.search(params[:search]).all
		authorize! :read, @section			 	
		@default_tab = 'students'
	    respond_to do |format|
			format.html {render :section_searches_box}
			format.xml  { render :xml => @students }
			format.js
    	end
    end		
	 
	 def section_marks
	 	@section=Section.find(params[:section_id])	 	
		@marks = Mark.search(params[:search]).all
		authorize! :read, @section				 
		 @default_tab = 'marks'
	    respond_to do |format|
			format.html {render :section_searches_box}
			format.xml  { render :xml => @marks }
			format.js
    	end		 
	 end
	 
	 def branch_searches_box
	 	if !params[:branch_id]
		 	@branch = Branch.first
	 	else
	 		@branch = Branch.find(params[:branch_id])
 		end
		authorize! :read, @branch		 		
 		@default_tab='students'
	 end
	 	 
	 def branch_students
	 	@branch=Branch.find(params[:branch_id])
	 	@students = Student.search(params[:search]).all
		authorize! :read, @branch	 	
		@default_tab = 'students'
	    respond_to do |format|
			format.html {render :branch_searches_box}
			format.xml  { render :xml => @students }
			format.js
    	end				

	 end
	 
	 def branch_marks
	 	@branch=Branch.find(params[:branch_id])	 	
		 @marks = Mark.search(params[:search]).all
		authorize! :read, @branch			 
		 @default_tab = 'marks'
	    respond_to do |format|
			format.html {render :branch_searches_box}
			format.xml  { render :xml => @marks }
			format.js
    	end				 
	 end	 

	def mark_columns(section)
		h = Hash.new
		section.sec_sub_maps.each do |map|
			name =Subject.find(map.subject_id).name
			mark_col = "sub#{map.mark_column}"
			h[name] = mark_col
		end
		return h
	end	
	
end
