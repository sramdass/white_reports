class MarksController < ApplicationController
  def new
  end

  def section_any1_graphs
  	@section = Section.find(params[:section_id])
  	@type = params[:type]
  end
  
  	def index
	end
  
  
=begin	
-----------------------------------------------------------
		@students << {:name => "Jane", :marks =>  [3, 2, 1, 3, 4]  }
		@students << {:name => "Amy", :marks =>  [6, 1, 3, 4, 3] }
		@students << {:name => "Erin", :marks =>  [6, 4, 3, 1, 2]}
		@exams = ['I term', 'II term', 'III term', 'Quarterly', 'Half yearly']
------------------------------------------------------------
=end		

	def cols_and_spline
		
		type = params[:type]
		section = Section.find(params[:section_id])
		@series = []
		@categories = []
		hash = mark_columns(section)
		@y_axis_text = 'Marks'	
		
		if type.eql?('one_student')
			
			student = Student.find(params[:student_id])
			test_ids = params[:test_ids]
			subject_ids = params[:subject_ids]
			
			@title_text = "#{student.name} Marks"
			
			for map in section.sec_test_maps		
				#for the x-axis units
				@categories <<  Test.find(map.test_id).name
				#for the spline
			end
			for sub_id in subject_ids
				req_col =  hash[Subject.find(sub_id).name]	
				marks = []
				#Loop for each of the subjects
				for test_id in test_ids
					marks << Mark.by_test_id(test_id).by_student_id(student.id).first.send(req_col)
				end
				@series << {:name => Subject.find(sub_id).name, :marks => marks}
			end					
		
			
		elsif type.eql?('one_subject')
			subject = Subject.find(params[:subject_id])
			test_ids = params[:test_ids]			
			student_ids =  params[:student_ids].split(",")
			
			for map in section.sec_test_maps		
				#for the x-axis units
				@categories <<  Test.find(map.test_id).name
				#for the spline
			end
			req_col = hash[Subject.find(subject.id).name]	
			for id in student_ids
				marks = []
				#Loop for each of the subjects
				for test_id in test_ids
					marks << Mark.by_test_id(test_id).by_student_id(id).first.send(req_col)
				end
				@series << {:name => Student.find(id).name, :marks => marks}
			end							
			
		elsif type.eql?('one_test')
			test = Test.find(params[:test_id])
			subject_ids = params[:subject_ids]			
			student_ids =  params[:student_ids].split(",")						
			for map in section.sec_sub_maps		
				#for the x-axis units
				@categories <<  Subject.find(map.subject_id).name
				#for the spline
			end			
			for id in student_ids
				marks = Array.new
				#Loop for each of the subjects
				for sub_id in subject_ids
					req_col = hash[Subject.find(sub_id).name]	
					marks << Mark.by_test_id(test.id).by_student_id(id).first.send(req_col)
				end
				@series << {:name => Student.find(id).name, :marks => marks}
			end									
		end
	end
		
		
		
		
		
=begin
		
		
		@exams = []
		@students_and_marks = []
		@class_average = []
		student_ids = params[:student_ids].split(",")
		subject_ids = params[:subject_ids].split(",")
		section_ids = params[:section_ids].split(",")
		section = Section.find(section_ids.first)
		subject = Subject.find(subject_ids.first)
		hash = mark_columns(section)
		req_col = hash[subject.name]

		@title = "Comparing students in one subject across the tests"
		for map in section.sec_test_maps		
			@exams <<  Test.find(map.test_id).name
			@class_average << (Mark.total_on(section.id, subject.id, map.test_id))/section.students.count
		end			
		for id in student_ids
			marks = Array.new
			for map in section.sec_test_maps		
				marks << Mark.by_section_id(section.id).by_test_id(map.test_id).by_student_id(id).first.send(req_col)
			end
			@students_and_marks << {:name => Student.find(id).name, :marks => marks}
		end
	end
=end	
  
	
=begin	
-----------------------------------------------------------
		@students = ['jane', 'mary', 'arun']
		@subejcts_and_marks = {:name => "english", :marks = [1,4,5,6,7]}
		@subejcts_and_marks = {:name => "tamil", :marks = [1,4,5,6,7]}
		@subejcts_and_marks = {:name => "maths", :marks = [1,4,5,6,7]}				
------------------------------------------------------------
=end		

	def stacked_cols
		
		@students = []
		@subjects_and_marks = []
		
		student_ids = params[:student_ids].split(",")
		test_ids = params[:test_ids].split(",")
		section_ids = params[:section_ids].split(",")
		
		section = Section.find(section_ids.first)
		test = Test.find(test_ids.first)
		hash = mark_columns(section)
		
		#Fill up the student names here		
		for id in student_ids
				@students <<  Student.find(id).name
		end
		
		#Fill up the marks for all the students in each of the subjects
		hash.each do |subject_name, mark_col |
			marks = []
			for id in student_ids
				marks << Mark.by_section_id(section.id).by_test_id(test.id).by_student_id(id).first.send(mark_col)
			end
			@subjects_and_marks << {:name => subject_name, :marks => marks }
		end
	end
	
	def table_cols
		
	end
	
	def negative_stack
		
		@range = ['0-30', '31-50', '51-70', '71-80', '81-90', '91-100', '100 +'];
		section_ids = params[:section_ids].split(",")
		section = Section.find(section_ids.first)
		subject_ids = params[:subject_ids].split(",")
		subject = Subject.find(subject_ids.first)
		test_ids = params[:test_ids].split(",")		
		test = Test.find(test_ids.first)
				
		hash = mark_columns(section)
		req_col = hash[subject.name]
		
		marks = Mark.by_section_id(section.id).by_test_id(test.id).boys_only
		@boys = []
		@boys << marks.in_range(req_col, 0, 30).count * -1
		@boys << marks.in_range(req_col, 31, 50).count * -1
		@boys << marks.in_range(req_col, 51, 70).count * -1
		@boys << marks.in_range(req_col, 71, 80).count * -1
		@boys << marks.in_range(req_col, 81, 90).count * -1
		@boys << marks.in_range(req_col, 91, 100).count * -1
		@boys << marks.in_range(req_col, 101, 1000).count * -1
		
		marks = Mark.by_section_id(section.id).by_test_id(test.id).girls_only
		@girls= []
		@girls<< marks.in_range(req_col, 0, 30).count
		@girls<< marks.in_range(req_col, 31, 50).count
		@girls<< marks.in_range(req_col, 51, 70).count
		@girls<< marks.in_range(req_col, 71, 80).count
		@girls<< marks.in_range(req_col, 81, 90).count
		@girls<< marks.in_range(req_col, 91, 100).count
		@girls<< marks.in_range(req_col, 101, 1000).count
		
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
	
	def section_dyn_vals
		name_like = params[:q]
		type = params[:type]

		section = Section.find(params[:section_id])
		if type.eql?('subjects')
			@objects = Subject.by_section(section.id)
		elsif type.eql?('tests')
			@objects = Test.by_section(section.id)
		elsif type.eql?('students')			
			@objects = Student.by_section(section.id).name_like("%#{params[:q]}%")			
			#Student.where("section_id =? and name like ?", section.id, "%#{params[:q]}%")
		end
		
		respond_to do |format|
			format.html
			format.json { render :json => @objects.map(&:attributes) }
		end	
				
	end


end
