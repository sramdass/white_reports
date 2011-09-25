class MarksController < ApplicationController
  def new
  end

  def table
  end

def graphs	

	@student_ids = params[:student_ids].split(",")
	@subject_ids = params[:subject_ids].split(",")
	@section_ids = params[:section_ids].split(",")
	@section = Section.find(@section_ids.first)
	hash = mark_columns(Section.find(@section_ids.first))
	req_col = hash[Subject.find(@subject_ids.first).name]
	@h = LazyHighCharts::HighChart.new('graph') do |f|
		f.options[:chart][:defaultSeriesType] = "line"
		f.options[:chart][:inverted] = false
		f.options[:chart][:backgroundColor] = {
         :linearGradient => [0, 0, 0, 400],
         :stops=> [
            [0, 'rgb(96, 96, 96)'],
            [1, 'rgb(16, 16, 16)']
         ]
      }
		f.options[:legend][:layout] = "horizontal"
		f.options[:title] [:text] = "Comparision of students"
		f.options[:title][:x] = -20
		f.options[:subtitle] [:text] = "Source: ewatchdogs.in"
		f.options[:subtitle][:x] = -20
		for id in @student_ids
			d1 = Array.new
			d2 = Array.new
			for map in @section.sec_test_maps		
				#debugger
				d2 <<  Test.find(map.test_id).name
				m = Mark.by_section_id(@section.id).by_test_id(map.test_id).by_student_id(id).first.send(req_col)
				d1 << m
			end
			f.options[:xAxis][:categories] = d2
			f.series(:name=>Student.find(id).name, :data=>d1)
		end		    
	end 	
end
  
	def index
	end
	
	def clazzs
	  @clazzs = Clazz.where("name like ?", "%#{params[:q]}%")
	  respond_to do |format|
	    format.html
	    format.json { render :json => @clazzs.map(&:attributes) }
	  end
	end
	
	def sections
		name_like = params[:q]
		clazz_ids = params[:clazz_ids].split(",")
		@sections = Section.where(:name.matches => "%#{name_like}%", :clazz_id.in => clazz_ids)
		respond_to do |format|
			format.html
			format.json { render :json => @sections.map(&:attributes) }
		end
	end
	
def students
	name_like = params[:q]
	section_ids = params[:section_ids].split(",")
	@students = Student.where(:name.matches =>  "%#{name_like}%", :section_id.in => section_ids)
	respond_to do |format|
		format.html
		format.json { render :json => @students.map(&:attributes) }
	end
end

def subjects
	name_like = params[:q]
	section_ids = params[:section_ids].split(",")
	@subjects = Section.find(section_ids.first).subjects
	respond_to do |format|
		format.html
		format.json { render :json => @subjects.map(&:attributes) }
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
