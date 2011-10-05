class SearchesController < ApplicationController
	
  def index
  	@section = Section.find(33)
 # 	@students_search = Student.search(params[:search])
 #	@students = @students_search.all  	 
 @marks_search = Mark.search(params[:search])
 @marks = @marks_search.all  	
 
  end

  def new
  end

end
