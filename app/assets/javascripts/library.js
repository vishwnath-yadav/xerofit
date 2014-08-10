$( document ).ready(function() {
  
  // $(document).on("click", ".replace_video_btn", function() {
  //    // $('.upload_edit').css('display','none');
  //    // $('.replace_video').css('display','block');
  //    // $('.lib_edit_botom').css('display','none');
  //    $("#library_video_video").click();
  // });
  // $("input[type=text], textarea")
  $(document).on('keyup',"input[type=text], textarea", function(){
    var obj = $(this).closest('.exr_field_col').find('span.detail_char');
    var max_size = parseInt(obj.attr('data-size'));
    var size = $(this).val().length;
    var actual = max_size - size 
    obj.text(actual);
  });

  $(document).on("change keyup",".for_on_change",function(){
    $('.chg_save').removeClass('dis_link');
    check_require_field();
  });

  $(document).on("change keyup",".for_on_changed",function(){
    $('.chg_save').removeClass('dis_link');
  });
  
  $(document).on("click",".for_on_change1",function(){
    $('.chg_save').removeClass('dis_link');
    check_require_field();
  });

  $(document).on("click",".del",function(){
    $(this).find(".fancy_select").slideToggle();
  });

  $(document).on("click",".sub_arw ul li",function(){
    var sub_menu=$(this).attr('data-subgroup');
    var sub_cat=$(this).attr('data-subcat');
    var $parent = $(this).closest('ul');
    var menu = $parent.attr('data-group');
    var id = $parent.attr('data-id');
    $('.target_muscle_menu_'+id).val(menu);
    $('.target_muscle_submenu_'+id).val(sub_cat);
    $('.target_'+id).text(sub_menu);
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

  // Bootstrap Tooltips
  $('.control_bar_tooltip').tooltip({
    placement: 'bottom'
  });
});

function check_require_field(){
  var flag= 1;
  $(".for_on_change").each(function() {
    key = $(this).val();
    if(key == null || key == '')
    {
      flag=0;
    }
  });

  var target = $('.for_target_change').val();
  var len = $(".select_thumb").length;

  if((len <= 0)||(target == null)||(target == '')){
    flag = 0;
  }
  if(flag == 1){
    $('.chg_lin').removeClass('dis_link');
  }
  else{
    $('.chg_lin').attr('class','cancel_btn rht_active edit_lib chg_lin dis_link');
  }
  console.log(flag);
}

function show_text_actual_size(){
  $('.detail_char').each(function(){
    var size = $(this).attr('data-size');
    
    var input_len = $(this).closest('.exr_field_col').find('input, textarea').val().length;
     var actual = size - input_len; 
      $(this).text(actual);
  })
}

