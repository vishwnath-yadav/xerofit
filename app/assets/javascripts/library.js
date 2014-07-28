$( document ).ready(function() {
  prg = $("#progressbar");
  // $(document).on("click", ".replace_video_btn", function() {
  //    // $('.upload_edit').css('display','none');
  //    // $('.replace_video').css('display','block');
  //    // $('.lib_edit_botom').css('display','none');
  //    $("#library_video_video").click();
  // });
  $(document).on("click",".del",function(){
    $(this).find(".fancy_select").slideToggle();
  });

  $(document).on("click",".sub_arw ul li",function(){
    sub_menu=$(this).attr('data-subgroup');
    alert(sub_menu);
    $('.target_muscle_submenu').val(sub_menu);
    menu = $(this).closest('ul').attr('data-group');
    $('.target_muscle_menu').val(menu);
    alert(menu);
  });
  

  $(document).on("click",".upload_video", function(){
    $("#library_video_video").click();
  });

  $('#library_video_video').on('change', function(e) {
    var file = e.target.files[0];
    size = (file.size/1024/1024).toFixed(2);
    if(size > 1024 && $('#dragandrophandler').is(':visible')){
      alert("size cannot be greater than 1 GB");
    }
    else if(size > 250){
      alert("size cannot be greater than 250 MB");
    }
  else{
      upl = size/100;
      if($("#progressbar").length || $("#progressbar1").length){
        prg.parent().find('p').text(upl+' MB of '+size+' MB');
        prg.parent().find('h2').text(file.name);
      }
      $("#video_upload_form").submit();
  }
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




