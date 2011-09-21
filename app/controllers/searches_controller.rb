class SearchesController < ApplicationController
  def index
  	@search = Student.search(params[:search])
  	@students = @search.all
  end
end
