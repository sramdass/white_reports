$(function() {	
	
  	//Section graphs section
  	
$("form.sections_graph #student_ids").tokenInput(function() {  
		return '/marks/section_dyn_vals.json?type=students&section_id=' + $('form.sections_graph #section_id').val(); 	
	}, 	{
    crossDomain: false,
    theme: "facebook"
  });	
  
$("#event_attendees #teachers").tokenInput(function() {  
		return '/events/attendees_dyn_vals.json';
	}, 	{
    crossDomain: false,
    prePopulate: $("#teachers").data("pre"), 
    theme: "facebook"
  });	  
  
});