$( document ).ready(function() {

  $(document).on("click", ".replace_video_btn", function() {
     $('.upload_edit').css('display','none');
     $('.replace_video').css('display','block');
    $('.lib_edit_botom').css('display','none');
  });
 
  $('.type_select ul li').click(function(){
    $('#select_option').val("type");
    $('#select_option_val').val($(this).text());
    $('#search_grid_list_form').submit();
  });

  $(document).on("click", ".view_type", function(){
     var name = $(this).attr('data-name');
     if(name == "grid"){
      $('#grid_view').attr('class','grid_icon grid_icon_active grid_pointer view_type');
      $('#list_view').attr('class','list_icon grid_pointer view_type')
     }
     else{
      $('#grid_view').attr('class','grid_icon grid_pointer view_type');
      $('#list_view').attr('class','list_icon list_icon_active grid_pointer view_type');
     }
     $('#view_type').val(name);
     $('#search_grid_list_form').submit();
  });

  $(document).on("click","#lib_name_for_search",function(){
  	$('#search_grid_list_form').submit();
  });

  $('#search_lib_by_name').keypress(function(e){
      if(e.which == 13){//Enter key pressed
        $('#search_grid_list_form').submit();
      }
  });

   $(function () {
      $('.default').dropkick();
    });

   $(".full_workout").click(function(){
      $.fancybox.open({
            href: '#dragandrophandler',
            type: 'inline'
        });
      prg = $("#progressbar1");
    });
});
load_select_click = function() {
  $('.status_select ul li').click(function(){
    $('#status').val($(this).text());
    $('#search_grid_list_form').submit();
  });

  $('.type_select ul li').click(function(){
    $('#type').val($(this).text());
    $('#search_grid_list_form').submit();
  });
}




