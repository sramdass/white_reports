class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_profile
    before_filter :mailer_set_url_options
 
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
	
	private
	
	def current_profile
		#Destroying  a cookie using code just empties the cookie. So just checking for nil is not sufficient.
		if cookies[:auth_token] && !(cookies[:auth_token].empty?)
			@current_profile ||= Profile.find_by_auth_token!(cookies[:auth_token])
		end
	end
	
	def current_year
		"2010"
	end
	
	def default_mark_columns
		columns = Hash.new
		columns = { 'test_id' => :integer, 'student_id' => :integer, 'arrears' => :integer, 'rank' => :integer, 'remarks' => :string}
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

end  # end of ApplicationController
