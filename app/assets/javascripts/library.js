$( document ).ready(function() {
  $(document).on("change", ".sel_opt", function(){
     var name = $(this).attr('data-name');
     $('#select_option').val(name);
  });

  $(document).on("click", ".view_type", function(){
     var name = $(this).attr('data-name');
     $('#view_type').val(name);
     $('#search_grid_list_form').submit();
  });

  $(document).on("click","#lib_name_for_search",function(){
  	var type = $('#view_type').val();
  	var name = $('#search_lib_by_name').val();

  	url = '/libraries/library_search_by_name';
  	$.get(url, {name:name,type:type}, function (data) {
     });
  });

  $('#search_lib_by_name').keypress(function(e){
      if(e.which == 13){//Enter key pressed
        $('#lib_name_for_search').click();//Trigger search button click event
      }
  });
});

