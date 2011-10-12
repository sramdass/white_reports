class MarksController < ApplicationController
	
#---------Input view generator modules --------------------------#
	
	def section_any1_graphs
		@section = Section.find(params[:section_id])
		@type = params[:type]
		authorize! :read, @section
	end
  
	def section_range_graphs
		@section = Section.find(params[:section_id])
		@type = params[:type]
		authorize! :read, @section		
	end
	
	def section_total_graphs
		@section = Section.find(params[:section_id])
		@type = params[:type]		
		authorize! :read, @section			
	end	
	
	def student_total_graphs
		@student = Student.find(params[:student_id])
		authorize! :read, @student
	end	
	
	def student_master_graphs
		@student = Student.find(params[:student_id])
		@type = params[:type]
		authorize! :read, @student		
	end	

#---------END OF Input view generator modules---------------------#

#--------------------Graph generator modules---------------------#

	def cols_and_spline
		
		type = params[:type]
		section = Section.find(params[:section_id])
		@series = []
		@categories = []
		@average = []
		hash = mark_columns(section)
		@y_axis_text = 'Marks'	
		@subtitle_text = "Section: #{section.name}"
		
		# comparing multiple subjects and tests for one student
		#This will also be called from 'student_master_graphs' view, since that generates
		# graphs for only one student
		if type.eql?('one_student')
			student = Student.find(params[:student_id])
			test_ids = params[:test_ids]
			subject_ids = params[:subject_ids]
			
			@title_text = "#{student.name} Marks"
			
			for test_id in test_ids
				#for the x-axis units
				@categories <<  Test.find(test_id).name
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
		
		# comparing one subject in multiple tests for multiple students
		elsif type.eql?('one_subject')
			subject = Subject.find(params[:subject_id])
			test_ids = params[:test_ids]			
			student_ids =  params[:student_ids].split(",")
			@title_text = "#{subject.name} Marks"
			
			for test_id in test_ids	
				#for the x-axis units
				@categories <<  Test.find(test_id).name
				#for the spline
				#@average << (Mark.total_on(section.id, subject.id, map.test_id))/section.students.count
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
			
		#comparing multiple subjects in one test for multiple students
		elsif type.eql?('one_test')
			test = Test.find(params[:test_id])
			subject_ids = params[:subject_ids]			
			student_ids =  params[:student_ids].split(",")
			@title_text = "#{test.name} Marks"				
			for sub_id in subject_ids	
				#for the x-axis units
				@categories <<  Subject.find(sub_id).name
				#for the spline
				#@average << (Mark.total_on(section.id, map.subject_id, map.test.id))/section.students.count				
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
#-----------------------------------------------------------------------#		
	
	def stacked_cols				
		section = Section.find(params[:section_id])
		student_ids = params[:student_ids].split(",")
		#This line is needed when the call is coming from student_total_graphs.html.erb
		student_ids << params[:student_id] if params[:student_id]
		test = Test.find(params[:test_id])
		@title_text = "Comparing students total"
		@y_axis_title = "Total Marks"
		@subtitle_text = "Section: #{section.name}"
		generate_stacked_cols(section.id, [test.id], student_ids)
	end
	
	def generate_stacked_cols(section_id, test_ids, student_ids)
		@categories =[]
		@series = []	
		section = Section.find(section_id)	
		hash = mark_columns(section)

		#Ideally, either test_ids or student_ids will have only one element.
		#Put the bigger one (will it work for both the elements having multiple values? I do not know yet!) 
		#or the one that has multiple values in the category list 
		if test_ids.size > student_ids.size
			for test_id in test_ids
					@categories <<  Test.find(test_id).name
			end
		else		
			for id in student_ids
					@categories <<  Student.find(id).name
			end
		end
		#Fill up the marks for all the students in each of the subjects
		hash.each do |subject_name, mark_col |
			marks = []
			for test_id in test_ids
				for id in student_ids
					marks << Mark.by_section_id(section.id).by_test_id(test_id).by_student_id(id).first.send(mark_col)
				end
			end
			@series << {:name => subject_name, :marks => marks }
		end	
	end


#-----------------------------------------------------------------------#
	
	def negative_stack			
		type = params[:type]
		section = Section.find(params[:section_id])
		hash = mark_columns(section)
		@subtitle_text = "Section: #{section.name}"
		@range = ['0-30', '31-50', '51-70', '71-80', '81-90', '91-100', '100 +'];
		@series = []
		@negative_length = -20
		@positive_length = 20
		
		if type.eql?('range_1test_2subjects')
			test = Test.find(params[:test_id])
			subject_ids = params[:subject_ids]
			marks = Mark.by_section_id(section.id).by_test_id(test.id)
			@title_text = "#{Subject.find(subject_ids.first).name} vs  #{Subject.find(subject_ids.second).name} - #{test.name}"
			
			direction = 1
			for sub_id in subject_ids
				req_col = hash[Subject.find(sub_id).name]
				range_count = []			
				range_count <<  marks.in_range(req_col, 0, 30).count * direction
				range_count << marks.in_range(req_col, 31, 50).count * direction
				range_count << marks.in_range(req_col, 51, 70).count * direction
				range_count << marks.in_range(req_col, 71, 80).count * direction
				range_count << marks.in_range(req_col, 81, 90).count * direction
				range_count << marks.in_range(req_col, 91, 100).count * direction
				range_count << marks.in_range(req_col, 101, 1000).count * direction
				@series << {:name => Subject.find(sub_id).name, :count => range_count }
				direction = -1
			end
			
		elsif type.eql?('range_1subject_2tests')			
			subject = Subject.find(params[:subject_id])
			test_ids = params[:test_ids]
			@title_text = "#{subject.name} - (#{Test.find(test_ids.first).name} vs  #{Test.find(test_ids.second).name})"
			req_col = hash[subject.name]			
			direction = 1
			for test_id in test_ids
				marks = Mark.by_section_id(section.id).by_test_id(test_id)
				range_count = []			
				range_count <<  marks.in_range(req_col, 0, 30).count * direction
				range_count << marks.in_range(req_col, 31, 50).count * direction
				range_count << marks.in_range(req_col, 51, 70).count * direction
				range_count << marks.in_range(req_col, 71, 80).count * direction
				range_count << marks.in_range(req_col, 81, 90).count * direction
				range_count << marks.in_range(req_col, 91, 100).count * direction
				range_count << marks.in_range(req_col, 101, 1000).count * direction
				@series << {:name => Test.find(test_id).name, :count => range_count }
				direction = -1
			end			
			
		elsif type.eql?('range_gender')
			subject = Subject.find(params[:subject_id])
			test = Test.find(params[:test_id])
			@title_text = "Comparing boys and girls in #{subject.name} (#{test.name})"
			req_col = hash[subject.name]
			
			marks = Mark.by_section_id(section.id).by_test_id(test.id).boys_only
			range_count = []		
			range_count << marks.in_range(req_col, 0, 30).count * -1
			range_count<< marks.in_range(req_col, 31, 50).count * -1
			range_count<< marks.in_range(req_col, 51, 70).count * -1
			range_count<< marks.in_range(req_col, 71, 80).count * -1
			range_count<< marks.in_range(req_col, 81, 90).count * -1
			range_count<< marks.in_range(req_col, 91, 100).count * -1
			range_count<< marks.in_range(req_col, 101, 1000).count * -1
			@series << {:name => "Boys", :count => range_count }			 
			
			marks = Mark.by_section_id(section.id).by_test_id(test.id).girls_only
			range_count = []		
			range_count<< marks.in_range(req_col, 0, 30).count
			range_count<< marks.in_range(req_col, 31, 50).count
			range_count<< marks.in_range(req_col, 51, 70).count
			range_count<< marks.in_range(req_col, 71, 80).count
			range_count<< marks.in_range(req_col, 81, 90).count
			range_count<< marks.in_range(req_col, 91, 100).count
			range_count<< marks.in_range(req_col, 101, 1000).count										
			@series << {:name => "Girls", :count => range_count }			 
		end		
	end

#-------------- END OFGraph generator modules----------------#


#----UTILTIY MODULES FOR THIS CONTROLLER AND VIEW------#

	def mark_columns(section)
		h = Hash.new
		section.sec_sub_maps.each do |map|
			name =Subject.find(map.subject_id).name
			mark_col = "sub#{map.mark_column}"
			h[name] = mark_col
		end
		return h
	end
	
	
# TO DYNAMICALLY POPULATE THE TEXT FIELDS FOR THE GRAPHS INPUT
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

#--END OF UTILTIY MODULES FOR THIS CONTROLLER AND VIEW--#
end
