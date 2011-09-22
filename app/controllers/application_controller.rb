class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_profile
    before_filter :mailer_set_url_options
    before_filter { |c| Authorization.current_user = c.current_profile }
 
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to :back, :alert => "You are not allowed to access that page"
	end
    
    def mailer_set_url_options
    	ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
	end
	
	#---------------------------------------------------------------------------#
	#            MODULES TO CREATE, EDIT AND DELETE TABLES DYNAMICALLY                            #
	#---------------------------------------------------------------------------#
	def create_model_file(table_name)
		model_file = File.join("app", "models", table_name.singularize+".rb")
		model_name = table_name.singularize.capitalize
		File.open(model_file, "w+") do |f|
			#The following line can be used to set a particular table to the Model using 'set_table_name'
			# f << "class #{model_name} < ActiveRecord::Base \n set_table_name '#{table_name}' \n end"
			f << "class #{model_name} < ActiveRecord::Base \n end"
		end
	end
	
	#---------------------------------------------------------------------------#
	
	# This module will create a table and create a model file accordingly
	# in the app/models directory. 
	# Note that 'table_name' should be in plural
	def create_table(table_name, columns)
		if columns.empty?
			logger.debug "Unable to create table. Columns are empty."
			return false
		end
		begin
			ActiveRecord::Schema.define do
				create_table "#{table_name}" do |t|
					columns.each { |key, value| 				
						t.column key, value				
					}
					t.timestamps
				end
			end
			#create_model_file(table_name)
			return true
		rescue Exception => err
			logger.debug "Exception happened when creating table"
			logger.debug_variables(binding)
			return false
		end # end of begin / rescue block
	end # end of def create_table
	
	#---------------------------------------------------------------------------#
	
	def add_columns_to_table(table_name, columns)
		if columns.empty?
			logger.debug "Columns are empty. Issuing a No Op"
			return true
		end
		begin						
			ActiveRecord::Schema.define do							
				columns.each { |name, value| 				
					add_column(table_name, name, value)				
				}
			end
			return true
		rescue Exception => err
			logger.debug "Exception happened when adding columns to table"
			logger.debug_variables(binding)
			return false
		end # end of begin / rescue block		
	end
	
	#---------------------------------------------------------------------------#
	
	def delete_columns_from_table(table_name, columns)
		if columns.empty?
			logger.debug "Columns are empty. Issuing a No Op"
			return true
		end		
		begin						
			ActiveRecord::Schema.define do
				columns.each { |name| 				
					remove_column(table_name, name)
				}
			end
			return true
		rescue Exception => err
			logger.debug "Exception happened when deleting columns from table"
			logger.debug_variables(binding)
			return false
		end # end of begin / rescue block	
	end
	
	#---------------------------------------------------------------------------#
	
	def drop_table(table_name)
		begin						
			ActiveRecord::Schema.define do
				drop_table(table_name)
			end
			return true
		rescue Exception => err
			logger.debug "Exception happened when dropping table"
			logger.debug_variables(binding)
			return false		
		end # end of begin / rescue block	
	end
	
	#---------------------------------------------------------------------------#
	#        END OF MODULES TO CREATE, EDIT AND DELETE TABLES DYNAMICALLY               #
	#---------------------------------------------------------------------------#	
	
	# TODO need to make the required modules as private
	
	def current_profile
		#Destroying  a cookie using code just empties the cookie. So just checking for nil is not sufficient.
		if cookies[:auth_token] && !(cookies[:auth_token].empty?)
			@current_profile ||= Profile.find_by_auth_token!(cookies[:auth_token])
		end
	end
	
	#declarative authorization requires a current_user  method
	#def current_user
		#StudentContact.find_by_primary_email(@current_profile.email).student || 
		#TeacherContact.find_by_primary_email(@current_profile.email).teacher
	#end
	
	def current_year
		"2010"
	end
	
	def default_mark_columns
		columns = Hash.new
		columns = {'section_id' => :integer, 'test_id' => :integer, 'student_id' => :integer, 'total' => :float, 'arrears' => :integer, 'rank' => :integer, 'remarks' => :string}
		return columns
	end
	
	def hash_to_keys_array(hsh)
		keys = Array.new
		hsh.each do |k, v|
			keys << k
		end
		return keys		
	end
	
	def hash_to_values_array(hsh)
		values = Array.new
		hsh.each do |k, v|
			values << v
		end
		return values
	end
	
	def current_ability
		@current_ability ||= Ability.new(current_profile)
	end	
	
	#---TO build the marks table for a sections according to the test list and subject list of that section--#
	# This is called from sections_controller
	
	def build_marks_table(section_id, test_id)
		marks = Mark.find(:all,:conditions => {:section_id.eq => section_id, :test_id.eq => test_id })
	 	if (marks.empty?)
	 		for student in @section.students 
	 			m = Mark.new( {:section_id => @section.id, :test_id => test_id, :student_id => student.id })
	 			m.save!
	 		end
		end 				
	end		
	
	#-----------------End of build_marks_table
	
	 	def create_base_mark_table(table_name, subject_ids)
		debugger
  		# return as soon as an error is encountered. Othewise there is a chance that this true is returned
  		ret = true
  		columns = default_mark_columns
		if new_table?(table_name) # Table for this 'section + year' is not there yet
		  	subject_ids.each do |sid|
				#column_name = Subject.find(sid).name
				column_name = "sub_#{sid}"
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
  			subject_ids.each do |sid|
				column_name =  "sub_#{sid}"
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
			if  source_columns.count > subject_ids.count + default_mark_columns.count
				target_columns = hash_to_keys_array(default_mark_columns)
				subject_ids.each do |sid|
					target_columns <<  "sub_#{sid}"
				end
				source_columns.each do |col_name|
					delete_columns << col_name unless target_columns.include?(col_name)
				end
				ret = delete_columns_from_table(table_name, delete_columns) unless delete_columns.empty?
				return ret
			end
			
			return ret			
			
		end # end of if newtable
	end #end of mark_table --------------------------#
	
	
		def new_table?(table_name)
		if MarkRecDefn.find_by_name(table_name)
			return false
		else
			return true
		end
	end
#-----------------------------------------------------------#  

end  # end of ApplicationController
