
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".tfields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(function() {	
			  
	//Currently the code is repeated for all the models. This should be made generic in future
	//INSTITUTIONS
  	$("#institutions th a, #institutions .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
  	//This is currently used with the key up function, so that the search is performed on every key press.
  	//If this needs to be used with form submit function, use
  	//$("#institutions_search ").submit(function(){  -> in the next line.
    $("#institutions_search input").keyup(function() {
    	$.get($("#institutions_search").attr("action"), $("#institutions_search").serialize(), null, "script");
    	return false;
  	});
  	
  	//CLAZZS (Classes)
  	 $("#clazzs th a, #clazzs .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#clazzs_search input").keyup(function() {
    	$.get($("#clazzs_search").attr("action"), $("#clazzs_search").serialize(), null, "script");
    	return false;
  	});
  	
  	 //BRANCHES
  	 $("#branches th a, #branches .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#branches_search input").keyup(function() {
    	$.get($("#branches_search").attr("action"), $("#branches_search").serialize(), null, "script");
    	return false;
  	});
  	
  	//TEACHERS
  	 $("#teachers th a, #teachers .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#teachers_search input").keyup(function() {
    	$.get($("#teachers_search").attr("action"), $("#teachers_search").serialize(), null, "script");
    	return false;
  	});
  	
  	 //SECTIONS
  	 $("#sections th a, #sections .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#sections_search input").keyup(function() {
    	$.get($("#sections_search").attr("action"), $("#sections_search").serialize(), null, "script");
    	return false;
  	});
  	
  	//SUBJECTS
  	$("#subjects th a, #subjects .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#subjects_search input").keyup(function() {
    	$.get($("#subjects_search").attr("action"), $("#subjects_search").serialize(), null, "script");
    	return false;
  	});
  	
  	//STUDENTS
  	$("#students th a, #students .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#students_search input").keyup(function() {
    	$.get($("#students_search").attr("action"), $("#students_search").serialize(), null, "script");
    	return false;
  	});
  	
  	//TESTS
  	$("#tests th a, #tests .pagination a").live("click", function() {
    	$.getScript(this.href);
    	return false;
  	});
  
    $("#tests_search input").keyup(function() {
    	$.get($("#tests_search").attr("action"), $("#tests_search").serialize(), null, "script");
    	return false;
  	});
  	
});