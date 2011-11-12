module ApplicationHelper
	def title (name)
		name
	end
	
	def default_tab?(action)
		@default_tab == action
	end
	
	def sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "arrow #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end
	
	
	def link_to_remove_fields(name, f)
		f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
	end
	  

	# If extra local variables have to passed to the partial, they will passed in to params
	# If no extra variables are required, a blank hash will be used as a default value.	
	def link_to_add_fields(name, f, association, params={})
		new_object = f.object.class.reflect_on_association(association).klass.new
		fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
			#merge the params hash with the form builder being sent as a local variable to the partial
	  		render(association.to_s.singularize + "_fields", {:f => builder}.merge(params))
		end
		link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
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
	
 	def no_search_matches()	
 		return 'Oops!..There are no items matching your search criteria'
 	end
 	
 	def printable(events)
 		str = ""
 		events.each do |e|
 			str = str + link_to (e.name, event_path(e)) + " | "
 		end
 		return str
 	end
	
end
	

