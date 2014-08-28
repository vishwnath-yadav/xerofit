$(document).ready(function(){

  // $(document).on("click", ".replace_video_btn", function() {
  //    $('.upload_edit').css('display','none');
  //    $('.replace_video').css('display','block');
  //    $('.lib_edit_botom').css('display','none');
  // });
  $(document).on('keyup blur',"input[type=text], textarea", function(){
    var obj = $(this).closest('.input_field_wrap').find('span.detail_char');
    var max_size = parseInt(obj.attr('data-size'));
    var size = $(this).val().length;
    var actual = max_size - size
    obj.text(actual);
  });

  $(document).on("change keyup",".for_on_change",function(){
    $('.chg_save').removeClass('dis_link');
    check_require_field();
  });

  $(document).on("change keyup click dblclick",".for_on_changed",function(){
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
    $('.target_'+id).text(sub_menu).css('border', '1px solid #e1e0dd');
    $(".error_msg_"+id).removeClass('lib_error').text("");
  });


  $(document).on('click','.type_select ul li', function(){
    $('#select_option').val("type");
    $('#select_option_val').val($(this).text());
    $('#search_grid_list_form').submit();
  });

  // Switch between Grid View and List View on Library Home
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

  // Search functionality on Library Index
  $(document).on("click","#lib_name_for_search",function(){
  	$('#search_grid_list_form').submit();
  });

  $(document).on("click",".search_bar_clear",function(){
    $("#search_lib_by_name").val('');
    $(".search_bar_clear").addClass('hide');
    $('#search_grid_list_form').submit();
  });

  $(document).on("keyup, mouseup", '#search_lib_by_name', function(e){
      $(".search_bar_clear").removeClass('hide');
      if(e.which == 13){//Enter key pressed
        $('#search_grid_list_form').submit();
      }
  });

  $(document).on("blur", '#search_lib_by_name', function(e){
      $(".search_bar_clear").addClass('hide');
  });

  $('#search_lib_by_name').bind('railsAutocomplete.select', function(event, data){
    $('#search_grid_list_form').submit();
  });

  $(document).on("click",".table_header > .column_sort",function(){
    var $header = $(this);                    // Get the header
    var order = $header.attr('data-sort');    // Get value of data-sort attribute
    var column = $header.html();
    $header.attr('data-order', $header.attr('data-order') == 'DESC' ? 'ASC' : 'DESC');
    if ($header.is('.ascending') || $header.is('.descending')) {
      $header.toggleClass('ascending descending');
    }else{
      $header.addClass('descending');
      $header.siblings().removeClass('ascending descending');
    }
    $("#order").val($header.hasClass('ascending') ? 'ASC' : 'DESC');
    $("#sort_arrow").val($header.hasClass('ascending') ? 'ascending' : 'descending')
    $("#sorted_by").val(order);
    $('#search_grid_list_form').submit();
  });

  $(document).on("click","#lib_name_for_search",function(){
    $('#search_grid_list_form').submit();
  });

  $(document).on('dblclick','.dblclk_add ul li',function(){
    $(this).addClass('selected_equipment');
    var value = $(this).text();
    $('.equip_hid').each(function(){
      if($('.close_equip:visible').size() < 5){
        if($(this).val() == ''){
          var id = $(this).attr('id').split("_")[2];
          $(this).val(value);
          $('#equip_div_'+id).removeClass('hide').addClass('equipment_pill').find('span.fl_text').text(value);
          return false;
        }
      }else{
        alert("You can only select up to 5 pieces of equipment");
        return false;
      }
    });
  });

  $(document).on('click','.equip_close_icon',function(){
    var id = $(this).attr('data-id');
    $("#equip_hid_"+id).val('');
    $("#equip_div_"+id).addClass('hide').find('span.fl_text').text('');
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
    $('.library_item_status').html('<img src="/assets/icons/status_icon_purple.png"> '+STATUS[3])
    $('.chg_save').attr('lib-status', STATUS[3]);
  }
  else{
    $('.chg_lin').attr('class','cancel_btn rht_active edit_lib dis_link chg_lin btn_right');
    var status_icon = $('.library_item_status').attr('data-status-icon');
    var status = $('.library_item_status').attr('data-status');
    status_icon = status == STATUS[3] ? '/assets/icons/status_icon_gray.png' : status_icon
    status = status == STATUS[3] ? STATUS[4] : status
    $('.chg_save').attr('lib-status', status);
    $('.library_item_status').html('<img src="'+status_icon+'"> '+status)
  }
}

function show_text_actual_size(){
  $('.detail_char').each(function(){
    var size = $(this).attr('data-size');
    var input_len = $(this).closest('.input_field_wrap').find('input, textarea').val().length;
     var actual = size - input_len;
      $(this).text(actual);
  })
}

$(document).mouseup(function (e)
{
    var container = $(".fancy_select.target_muscle_select");

    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});
