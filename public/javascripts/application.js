
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".tfields").hide();
  	update_row_count();  
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  /*$(link).parent().parent().before(content.replace(regexp, new_id));*/
  $(".input_form_table").append(content.replace(regexp, new_id));
  
	//Update the current number of rows the user sees
	update_row_count();  
}

function update_row_count(){
	 //reduce one to count out the table headings
	var row_count = $(".input_form_table tr").length - 1;
  $("#input_table_row_count").html("<h3> Total:  " + row_count + "</h3>");	
}

$(function() {	
	
	update_row_count();  
	
	//COMMON
	//Initially hide all the divs
	$("#main-column div.cantoggle").hide();
	
	//Initially hide the header drop down box
	$('#header-drop-down').hide();
	
	
	//Show the default divs
	selected_tab_link = $("#nav-column ul.nav-list li a.selected")
	selected_tab_link_id = selected_tab_link.attr('id')
	hashed_id =  '#' + selected_tab_link_id
	default_div_2_show = "#main-column" + " " + hashed_id
	$(default_div_2_show).show();	
	
	//For the menu items in the #tab_bar
	$("#nav-column ul.nav-list li a").live('click', function() {
		$("#nav-column ul.nav-list li a").removeClass("selected");
		$(this).addClass("selected");
		hashed_id =  '#' + $(this).attr('id')
		div2show = "#main-column" + " " + hashed_id
		$("#main-column div.cantoggle").hide();
		$(div2show).show();	
		return false;
	});

	
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
  	
  	//**************************fb_design******************************//
  	
  	$("#tab-bar ul li a").live('click', function() {
		$("#tab-bar ul li a").removeClass("selected");
		$(this).addClass("selected");
		return false;
	});
	

	$(this).click(function() {
		$('#header-drop-down').hide();
		return false;
	});	
			
	$('#header-drop-down-list').click(function() {
		$('#header-drop-down').show();
		return false;
	});
  	
});