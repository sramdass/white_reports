class SearchesController < ApplicationController
	
	 def section_searches_box
	 	if !params[:section_id]
		 	@section = Section.first
	 	else
	 		@section = Section.find(params[:section_id])
 		end
 		@default_tab='students'
	 end
	 
	 def section_students
	 	@section=Section.find(params[:section_id])
	 	@students = Student.search(params[:search]).all
		@default_tab = 'students'
		render :section_searches_box
	 end
	 
	 def section_marks
	 	@section=Section.find(params[:section_id])	 	
		 @marks = Mark.search(params[:search]).all
		 @default_tab = 'marks'
		 render :section_searches_box
	 end
	 
	 def branch_searches_box
	 	if !params[:branch_id]
		 	@branch = Branch.first
	 	else
	 		@branch = Branch.find(params[:branch_id])
 		end
 		@default_tab='students'
	 end
	 	 
	 def branch_students
	 	@branch=Branch.find(params[:branch_id])
	 	@students = Student.search(params[:search]).all
		@default_tab = 'students'
		render :branch_searches_box
	 end
	 
	 def branch_marks
	 	@branch=Branch.find(params[:branch_id])	 	
		 @marks = Mark.search(params[:search]).all
		 @default_tab = 'marks'
		 render :branch_searches_box
	 end	 

end
