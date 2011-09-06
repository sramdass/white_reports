logger = ActiveRecord::Base.logger

# To debug all the instance variable for a particular binding
#  Call as  'logger.debug_variables(binding)'
def logger.debug_variables(bind)
	vars = eval('local_variables + instance_variables', bind)
	vars.each do |var|
		debug  "#{var} = #{eval(var, bind).inspect}"
	end
end